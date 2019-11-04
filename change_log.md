# changelog

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
