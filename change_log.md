# changelog

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
