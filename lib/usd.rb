#

require 'rest-client'
require "base64"
require "json"
require "yaml"
require 'uri'
require "time"
require 'tempfile'

class Usd

  CN={
    "chg" => "chg_ref_num",
    "cnt" => "combo_name",
    "arcpur_rule" => "name",
    "ca_tou" => "name",
    "cost_cntr" => "name",
    "country" => "name",
    "dept" => "name",
    "gl_code" => "name",
    "job_func" => "name",
    "loc" => "name",
    "nr" => "name",
    "opsys" => "name",
    "org" => "name",
    "tab" => "name",
    "auto_close" => "sym",
    "aty" => "sym",
    "act_type_assoc" => "sym",
    "ca_cmpny" => "sym",
    "closure_code" => "sym",
    "cmth" => "sym",
    "symptom_code" => "sym",
    "state" => "sym",
    "crt" => "sym",
    "ctab" => "sym",
    "ctp" => "sym",
    "dcon_typ" => "sym",
    "dlgsrvr" => "sym",
    "dmn" => "sym",
    "doc_rep" => "sym",
    "fmgrp" => "sym",
    "ical_alarm" => "sym",
    "ical_event_template" => "sym",
    "imp" => "sym",
    "intfc" => "sym",
    "kwrd" => "sym",
    "mfrmod" => "sym",
    "mgsstat" => "sym",
    "nrf" => "sym",
    "options" => "sym",
    "outage_type" => "sym",
    "perscnt" => "sym",
    "position" => "sym",
    "pr_trans" => "sym",
    "prod" => "sym",
    "quick_tpl_types" => "sym",
    "rc" => "sym",
    "resocode" => "sym",
    "resomethod" => "sym",
    "response" => "sym",
    "rrf" => "sym",
    "rss" => "sym",
    "seq" => "sym",
    "sev" => "sym",
    "site" => "sym",
    "slatpl" => "sym",
    "special_handling" => "sym",
    "svc_contract" => "sym",
    "typecnt" => "sym",
    "tz" => "sym",
    "tspan" => "sym",
    "transition_type" => "sym",
    "urg" => "sym",
    "vpt" => "sym",
    "wrkshft" => "sym",
    "cr" => "ref_num",
    "in" => "ref_num",
    "pr" => "ref_num"
  }

  RestClient.proxy = ""

  attr_reader :base_url, :user, :access_key, :expiration_date, :debug
  attr_writer :debug

  def initialize(user, password="", base_url = "http://localhost:8050", hash={})
    hash = {:expiration_date => 0, :access_key => "",:save_access_key => true }.update hash
    make_new = true
    @base_url = base_url
    @user = user
    @debug = false
    remfile = "#{ENV["HOME"]}/.usd"
    if File.exist?(remfile) and hash[:save_access_key]
      tt = YAML.load(File.open(remfile,"r"))
      if (tt.expiration_date - Time.now.to_i ) > 900 and tt.base_url == base_url
        @access_key = tt.access_key
        @expiration_date = tt.expiration_date
        make_new = false
        puts "cache key loaded..." if @debug
      end
    end
    if hash[:save_access_key] and hash[:access_key].length > 0
      if (hash[:expiration_date] - Time.now.to_i ) > 900
        @access_key = hash[:access_key]
        @expiration_date = hash[:expiration_date]
        make_new = false
        puts "use existing access_key ..." if @debug
      end
    end
    if make_new
      encoded=Base64.encode64( "#{@user}:#{password}")
      begin
        response = RestClient::Request.execute(method: :post, url: "#{@base_url}/caisd-rest/rest_access?_type=json",
          payload: '<rest_access/>',
          headers: {
            'content-type' => "application/xml",
            "accept" => "application/json",
            "authorization" =>  "Basic #{encoded}",
            "cache-control" => "no-cache"
          },
          log: Logger.new(STDOUT)
        )
        authData=JSON.parse(response.body)
        if authData['rest_access']['access_key'] > 0
          @access_key = authData['rest_access']['access_key']
          @expiration_date = authData['rest_access']['expiration_date']
          if hash[:save_access_key]
            f=File.open(remfile,"w")
            f.puts self.to_yaml
            f.close
          end
        else
          "keinen Accesskey erhalten. \nresponse.body:\n#{response.body}"
        end
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end
  end

  def self.loadcon
    # load from env
    Usd.new(ENV["usduser"],ENV["usdpass"],ENV["usdurl"])
  end

  def header(hash={})
    hash = {
      'x-accesskey' => @access_key,
      'accept' => "application/json",
      "Content-Type" =>"application/json; charset=UTF-8",
      'X-Obj-Attrs' => "*",
      'cache-control'=> "no-cache"
    }.update hash
    hash
  end

  def request(uri, hash={})
    RestClient.log = STDOUT if @debug
    hash = {:method => "get", :header => header(), :unchanged => false, :json => "", :base_url => @base_url}.update hash
    puts "request - hash: #{JSON.pretty_generate(hash)}" if @debug
    if (uri !~ /^http/)
      url = URI.escape("#{hash[:base_url]}#{uri}")
    else
      url = URI.escape(uri)
    end
    begin
      if hash[:method] == "get"
        response = RestClient::Request.execute(method: hash[:method], url: url, headers: hash[:header])
      elsif   hash[:method] == "post"
        response = RestClient.post(url, hash[:json], hash[:header])
      elsif   hash[:method] == "put"
        response = RestClient.put(url, hash[:json], hash[:header])
      elsif   hash[:method] =~ /delete/i
        response = RestClient.delete(url, hash[:header])
      end
      if hash[:unchanged]
        response.body
      else
        JSON.parse(response.body)
      end
    rescue RestClient::ExceptionWithResponse => e
      e
    end
  end

  def create(hash = {})
    hash = {:type => "ruby", :data => {}}.update hash
    case hash[:type]
    when "ruby"
      data = hash[:data]
    when "json"
      data = JSON.parse(hash[:data])
    when "yaml"
      data = YAML.load(hash[:data])
    else
      "Error: 'data[:type]': '#{hash[:data]}' not found!"
    end
    puts "create - data: #{JSON.pretty_generate(data)}" if @debug
    object = data.keys[0]
    uri = "/caisd-rest/#{object}"
    request("/caisd-rest/#{object}",{:method => "post", :json => data.to_json})
  end

  def update(hash = {})
    hash = {:type => "ruby", :data => {}}.update hash
    case hash[:type]
    when "ruby"
      data = hash[:data]
    when "json"
      data = JSON.parse(hash[:data])
    when "yaml"
      data = YAML.load(hash[:data])
    else
      "Error: 'data[:type]': '#{hash[:data]}' not found!"
    end
    puts "update - data: #{JSON.pretty_generate(data)}" if @debug
    object = data.keys[0]
    if  data[object].has_key?("@id")
      request("/caisd-rest/#{object}/#{data[object]["@id"]}",{:method => "put", :json => data.to_json, :header => header({'X-Obj-Attrs' => 'COMMON_NAME'})})
    elsif data[object].has_key?("@COMMON_NAME")
      request("/caisd-rest/#{object}/COMMON_NAME-#{data[object]["@COMMON_NAME"]}",{:method => "put", :json => data.to_json, :header => header({'X-Obj-Attrs' => 'COMMON_NAME'})})
    else
      puts "specify @COMMON_NAME or @id at least."
    end
  end

  def set_url_parm(params_hash,attribute_name,default)
    # disable case
    params_hash.keys.each do |k|
      if k =~ /^#{attribute_name}$/i
        v = params_hash[k]
        params_hash.delete(k)
        params_hash[attribute_name] = v
      end
    end
    "#{attribute_name}=#{params_hash[attribute_name]?params_hash[attribute_name]:default}"
  end

  def set_param(params_hash,attribute_name,default)
    params_hash[attribute_name]?params_hash[attribute_name]:default
  end

  def search(object,params={})
    attr=[]
    attr.push set_url_parm(params,"SORT","id DESC")
    attr.push set_url_parm(params,"start","1")
    attr.push set_url_parm(params,"size","50")
    attr.push set_url_parm(params,"WC","")
    # if wc contains no sql-compare operater, it will be changed to "COMMON_NAME like '%<wc-before>%'"
    wc = attr.pop
    wc.gsub!(/^WC=/,'')
    if ([" like ","<",">","="," is "," in "," LIKE ", " IS ", " IN "].find {|e| wc =~ /#{e}/}).nil?
      wc = "#{CN[object]} like '%#{wc}%'"
    end
    attr.push "WC=#{wc}"
    # puts attr.jp # debug
    fields = set_param(params,"fields","COMMON_NAME,id")
    query_string=attr.join("&")
    res_rdata = request("/caisd-rest/#{object}?#{query_string}",{:method => "get", :header => header({'X-Obj-Attrs' => fields})})
    puts res_rdata if @debug
    count = res_rdata["collection_#{object}"]["@COUNT"].to_i
    start = res_rdata["collection_#{object}"]["@START"].to_i
    total_count = res_rdata["collection_#{object}"]["@TOTAL_COUNT"].to_i
    # turn throught the pages
    if count == 1
      [res_rdata["collection_#{object}"][object]]
    elsif count == 0
      []
    else
      retArray = res_rdata["collection_#{object}"][object]
      if total_count > (count + start - 1)
        new_params = {"start" => (start + 50)}
        params = params.update new_params
        retArray += search(object,params)
      end
      retArray
    end
  end

  def upload_attachment(file, baseurl = @base_url, ak = @access_key)
    baseurl =~ /^([^:]+):/
    server = $1
    filename = File.basename(file)
    filename_escaped = URI.escape(filename)
    uri = "/caisd-rest/attmnt?repositoryId=1002&serverName=#{server}&mimeType=Text&description=#{filename_escaped}"
    url = URI("#{baseurl}#{uri}")
    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request["X-AccessKey"] = ak
    request["Content-Type"] = "multipart/form-data; BOUNDARY=*****MessageBoundary*****"
    request["accept"] = "application/json"
    request["Cache-Control"] = "no-cache"
    fileObj = File.open(file, "rb")
    fileContent = fileObj.read
    fileObj.close
    request.body = "--*****MessageBoundary*****\r\n \r\nContent-Disposition: form-data; name=\"payload\" \r\nContent-Type: application/xml; CHARACTERSET=UTF-8 \r\n\r\n \r\n<attmnt> \r\n<repository id=\"1002\"></repository> \r\n<orig_file_name>#{filename_escaped}</orig_file_name> \r\n<attmnt_name>#{filename_escaped}</attmnt_name> \r\n<description>Uploaded with rusdc from rubygem usd</description> \r\n</attmnt> \r\n\r\n \r\n--*****MessageBoundary*****\r\n \r\nContent-Disposition: form-data; name=\"#{filename_escaped}\"; filename=\"#{filename_escaped}\" \r\nContent-Type: application/octet-stream \r\nContent-Transfer-Encoding: base64\r\n\r\n#{Base64.encode64(fileContent)}\r\n\r\n \r\n--*****MessageBoundary*****--\r\n"
    response = http.request(request)
    response.read_body
  end

end

module Jsonpretty
  def jp
    # return in json_pretty
    JSON.pretty_generate(self)
  end
  def jpp
    # print in json_pretty
    puts JSON.pretty_generate(self)
  end
end

class Hash
  include Jsonpretty
end

class Array
  include Jsonpretty
end
