
# usd - Ruby Class for SDM REST-API-Calls

There is a ruby class and a commandline tool rusdc.

[![asciicast](https://asciinema.org/a/7zw3RLpikFluqX9XJMxCpMEmS.svg)](https://asciinema.org/a/7zw3RLpikFluqX9XJMxCpMEmS)

# installation

just install the gem:

```bash
gem install usd
```

Be aware that you need some compiler-tools and the ruby headers:

```bash
# ubuntu
sudo apt-get install build-essential ruby-dev
# redhat
yum group install "Development Tools"
yum install ruby-devel
```

# documentation

- see [https://github.com/ogaida/usd/wiki](https://github.com/ogaida/usd/wiki)
- if you are looking for dependencies in between the objects, objectnames or relational objects, then have a look at [techdocs.broadcom.com](https://techdocs.broadcom.com/content/broadcom/techdocs/us/en/ca-enterprise-software/business-management/ca-service-management/14-1/reference/ca-service-desk-manager-reference-commands/objects-and-attributes.html)

## bash-completion

see [https://github.com/ogaida/usd/wiki/bash-completion](https://github.com/ogaida/usd/wiki/bash-completion)

# external tools / requirements

If you use the `rusdc find` command with `--format mlr` option then you need `mlr`.

- [mlr - Miller](http://johnkerl.org/miller/doc/index.html) - a great tool for data-transforming to and from json, csv and many more

Place the `mlr`-binary in a path, which is in your PATH-Environment. Download-Url for mlr-releases: [https://github.com/johnkerl/miller/releases](https://github.com/johnkerl/miller/releases).

# functions from the commandline-tool `rusdc`

```
rusdc chg_add_attachment <co> <file>                                         # attach the file to co
rusdc chg_add_nr <co> <ci>                                                   # add a CI to a changeorder
rusdc chg_list_nr <co>                                                       # list all CIs of one changeorder
rusdc create                                                                 # pipe json-data to create object
rusdc field_names <object-type> [wc]                                         # list all fields of an object including its format
rusdc find <object-type> [where-clause] [fields, comma separated] [options]  # finds each object which meets the wc-condition
rusdc get <object-type> <common_name|id>                                     # shows one object by name or id
rusdc get_all_attachments_of_co <co_name>                                    # get all attachments of a changeorder and save all these to current folder
rusdc get_attachment_of_ci <ci_name> <filename>                              # download an attachment of a CI and print it out on stdout
rusdc get_attachment_of_co <co_name> <filename>                              # download an attachment of a changeorder and print it out on stdout
rusdc get_attachment_of_in <incident> <filename>                             # download an attachment of an Incident and print it out on stdout
rusdc help [COMMAND]                                                         # Describe available commands or one specific command
rusdc in_add_2_chg <changeorder> <incident>                                  # add incident to changeorder
rusdc in_add_attachment <in> <file>                                          # attach a file to an incident or problem
rusdc in_list_child_ins <in>                                                 # list all child-incidents of one incident
rusdc list_attachments_of_ci <ci_name>                                       # list all attachments of a CI
rusdc list_attachments_of_co <co_name>                                       # list all attachments of a changeorder
rusdc list_attachments_of_in <in>                                            # list all attachments of an incident or problem
rusdc nr_add_attachment <nr> <file>                                          # attach the file to nr
rusdc nr_add_child <nr-name> <child-name>                                    # add one child CI to another CI
rusdc nr_add_contact <nr> <cnt_email>                                        # add contact to configuration-item
rusdc nr_add_org <nr> <org>                                                  # add an Organisation to a ConfigurationItem
rusdc nr_changes <nr> [inactive-too]                                         # list all open changeorders of one CI
rusdc nr_childs <ci-name>                                                    # lists all childs CIs of a specific CI
rusdc nr_incidents <nr> [inactive-too]                                       # lists all incident of a specific CI
rusdc nr_parents <ci-name>                                                   # lists all parent CIs of a specific CI
rusdc update                                                                 # pipe json-data to update object
rusdc update_attr <obj> <common_name|wc> <key> <value>                       # updates a direct (not referenced) attribute of one or more objects.
rusdc update_attr_by_id <obj> <id> <key> <value>                             # updates a plain attribute of one object by id, does not work
rusdc update_ref_attr <obj> <common_name> <key> <value> [ref_obj=nr]         # updates a referenced attribute of one object.
rusdc update_ref_attr_by_id <obj> <id> <key> <value_id>                      # updates a referenced attribute of one object_id by value-id
rusdc vcard_via_email <email>                                                # creates a vcard from the given email-address and saves it in the /tmp directory.
```

# environment-variables

rusdc needs some environment-variables. there are:

```
usduser
usdpass
usdurl
```

you may set and export them via script:

```bash
#!/usr/bin/env bash
# load with `source ./set_env`

export usduser=<your username>
export usdurl="http://<your sdm server>:8050"
if [ -z "$usdpass" ]
then
  read -s -p "password for $usduser ? " usdpass
  echo ""
  export usdpass
fi
```

# example - find records

```bash
$ rusdc find nr "name like 'foo%'" name,description --format mlr
name  description
foo1  foo QS
foo2  foo TEST
```

more examples under [find examples-Wikipage](https://github.com/ogaida/usd/wiki/find-examples) or in the [change_log](https://github.com/ogaida/usd/blob/master/change_log.md)

# senarios

<img src="https://yuml.me/diagram/scruffy/class/[SDM%20REST-API{bg:red}]<->[usd-gem{bg:green}]<->[rusdc{bg:orange}],[ruby-script{bg:orange}]<->[usd-gem],[sinatra%20web-app{bg:orange}]<->[usd-gem],[bash commands]<->[rusdc],[shell-scripts]<->[rusdc],[import]->[ruby-script],[ruby-script]->[export],[reports]<-[sinatra%20web-app]<-[drop datafiles/emails/create objects]">

# feedback

Since I could only test this gem in a 14.1 environment, I would be interested to know whether it also works in a version 17 environment of CA Service Management. Any kind of feedback is very welcome.
