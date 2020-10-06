# rusdc changelog

## 1.3.7

- Bugfix in rusdc-function `get_attachment_of_co`

## 1.3.6

- Bugfix : uploaded filename with special character will be renamed with `URI.escape`

## 1.3.5

- new function `nr_add_contact <nr> <email>` to assign a contact to a configuration-item

## 1.3.4.1

- fixed another error in Usd.search. which comes with 1.3.1 .

## 1.3.4

- move function `upload_attachment` from `bin/rusdc` to `lib/usd`.

## 1.3.3

- private `rusdc`-funktion `upload_attachment` changed. Instead using `base64` and `unix2dos` binaries, we use Base64-Ruby-Class now. It is already required by usd.

## 1.3.2

- fixed error in Usd.search. which comes with 1.3.1 .

## 1.3.1

- new functions:
  - `chg_add_attachment`
  - `nr_add_attachment`
  - `in_add_attachment`
  - `vcard_via_email`

with the first three funtions you are able to upload files to changeorders, configurationitems and incidents and it does not matter if it is text or binary. the last new function creates vcards in version 2.1 from a contact via its email as identifier.

## 1.2

- now in Usd.search function:
  - whereclause is enriched with "common_name like '% wc%'" if it is not a valid whereclause.

## 1.0 and 1.1

- `update_ref_attr` rusdc-function fetches the IDs to update the object by itself.

## 0.3

- some common_name resolution

```ruby
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
end
```

## 0.2.5.3

- neu function : `rusdc nr_add_org <nr> <org>  # add an Organisation to a ConfigurationItem`

#### fixes:

- rusdc - line 110: more robust when querying date fields

## 0.2.4.2

the same fixes as in 0.2.4.1 for:

```
rusdc list_attachments_of_ci <ci_name>
rusdc list_attachments_of_co <co_name>    
```

## 0.2.4.1

### fixes

- `rusdc get_attachment_of_ci` : attachment with spaces in path could not be downloaded

## 0.2.4

- find function has exitcode > 0 if no records has been found

```
$ rusdc find nr "name = 'not_here'"  || echo 'i am not here, please create me'
[]
i am not here, please create me
$ rusdc find cnt "last_name = 'Gaida'"  && echo 'i am here, you may update me'
[{
  "@COMMON_NAME": "Gaida, Oliver "
}]
i am here, you may update me
```

### fixes

- `rusdc get_all_attachments_of_co` : attachment with spaces in path could not be downloaded

## 0.2.3

- new function `in_add_2_chg` - add incident to changeorder

Usage:

```

  rusdc in_add_2_chg <changeorder> <incident>
```

Example:

```
$ rusdc find in "change.chg_ref_num = 'CO000001'"  --format mlr
@COMMON_NAME
I000001
I000002
$ rusdc in_add_2_chg CO000001 I000003
$ rusdc find in "change.chg_ref_num = 'CO000001'"  --format mlr
@COMMON_NAME
I000001
I000002
I000003
```

## 0.2.2

- extented function `update_attr`, now you may use a where-clause instead of a `common_name` to filter the object(s) to update

Example 1:

update many CIs with one statement...b

```bash
$ rusdc find nr "name like 'server[12]'" name,description --format mlr
name    description
server1 vorher
server2 vorher
$ rusdc update_attr nr "name like 'server[12]'" description "new description"
$ rusdc find nr "name like 'server[12]'" name,description --format mlr
name    description
server1 new description
server2 new description
```

Example 2:

update a CI which has a special attribute value:

```bash
$ rusdc find nr "serial_number = 'ABC123ABC987'" name,serial_number,warranty_end --format mlr
name    serial_number warranty_end
server1 ABC123ABC987  2020-11-30 00:00:00 +0100
$ rusdc update_attr nr "serial_number = 'ABC123ABC987'" warranty_end "01.02.2022"
$ rusdc find nr "serial_number = 'ABC123ABC987'" name,serial_number,warranty_end --format mlr
name    serial_number warranty_end
server1 ABC123ABC987  2022-02-01 00:00:00 +0100
```

## 0.2.1

- function `update_attr` has a new option for putting plain text with linebreaks in it.

- new funciton `update_ref_attr_by_id` sometimes there are problem if you try to update via common_name, so here you can use the `@id` instead.

- `rusdc get` now supports id too

- rusdc field_names , now there is a second parameter [wc]. So that's a way to show all fields of a special opbject.

Example:

```
rusdc field_names wf "@id = 1535123" | head -3
@COMMON_NAME (String) :
@REL_ATTR (String) : 1535123
@id (String) : 1535123
```

## 0.1.9

- function update_attr will parse with Time-Module if the key match the regular expression: `(date|last_mod|warranty_start|warranty_end|time_stamp)`. And then the value will be change to epoche-seconds

Example:

```
rusdc update_attr chg CO000001 call_back_date "2020-01-01 11:11:11 +0100"
```

- new function in rusdc `get_all_attachments_of_co`. In the first implementation it will save all attachments with its original name in the current folder. existing files may be overwritten. Caution!

## 0.1.8

- new function in rusdc `update_attr`

Example for `update_attr`:

```bash
> rusdc help update_attr
Usage:
  rusdc update_attr <obj> <common_name> <key> <value>

updates a direct (not referenced) attribute of one object.

> rusdc get cnt 'gaida, oliver' | grep alt_phone
  "alt_phone": "",
> rusdc update_attr cnt 'gaida, oliver' alt_phone "+49123456789"
> rusdc get cnt 'gaida, oliver' | grep alt_phone
  "alt_phone": "+49123456789",
```

- new function in rusdc `update_ref_attr`

Example for `update_ref_attr`:

```bash
> rusdc help update_ref_attr
Usage:
  rusdc update_ref_attr <obj> <common_name> <key> <value>

updates a referenced attribute of one object.
> rusdc find chg "chg_ref_num = 'CO000001'" status --format mlr
status
Work in progress
> rusdc update_ref_attr chg CO000001 status "Service pending"
> rusdc find chg "chg_ref_num = 'CO000001'" status --format mlr
status
Service pending
```

## 0.1.7

- fix sorting the output of `rusdc find`
- add new rusdc function `rusdc in_list_child_ins`
