
# usd - Ruby Class for SDM REST-API-Calls

There is a ruby class and a commandline tool rusdc.

# installation

just install the gem:

```bash
sudo gem install usd
```

Be aware that you need some compiler-tools and the ruby headers:

```bash
# ubuntu
sudo apt-get install build-essential ruby-dev
# redhat
yum group install "Development Tools"
yum install ruby-devel
```

# external tools

If you use the `rusdc find` command with `--format mlr` option then you need `mlr`.

- [mlr - Miller](http://johnkerl.org/miller/doc/index.html) - a great tool for data-transforming to and from json, csv and many more

Place the `mlr`-binary in a path, which is in your PATH-Environment.

# functions from the commandline-tool `rusdc`

```
rusdc
Commands:
  rusdc chg_add_nr              # <CO> <CI> - add a CI to a changeorder
  rusdc chg_list_nr             # <CO> - list all CIs of one changeorder
  rusdc create                  # pipe json-data to create object
  rusdc field_names             # <object-type> list all fields of an object including its format
  rusdc find                    # <object-type> <where-clause> [fields - Komma getrennt (id,name)] - finds each object which meets the wc-condition
  rusdc get                     # <object-type> <common_name> shows one object
  rusdc get_attachment_of_ci    # <ci_name> <filename>, download an attachment of a CI and print it out on stdout
  rusdc get_attachment_of_co    # <co_name> <filename>, download an attachment of a changeorder and print it out on stdout
  rusdc help [COMMAND]          # Describe available commands or one specific command
  rusdc in_list_child_ins       # <in> - list all child-incidents of one incident
  rusdc list_attachments_of_ci  # <ci_name>, list all attachments of a CI
  rusdc list_attachments_of_co  # <co_name>, list all attachments of a changeorder
  rusdc nr_add_child            # <nr-name> <child-name>, add one child CI to another CI
  rusdc nr_changes              # <nr> [inactive-too] - list all open changeorders of one CI
  rusdc nr_childs               # <ci-name> , lists all childs CIs of a specific CI
  rusdc nr_incidents            # <nr> [inactive-too] - lists all incident of a specific CI
  rusdc nr_parents              # nr_parents <ci-name> , lists all parent CIs of a specific CI
  rusdc update                  # pipe json-data to update object
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
