#ActiveAdminSimpleLife

About

Gem automatize routine with creation simple menus in ActiveAdmin with minimum 
code duplication. 

###Installation

put in `Gemfile` 

`gem 'active_admin_simple_life'`

###Usage

For all gem methods you need to present class method(NOT scope!) `main_fields`, 
where you provide columns, which you would like to manage. Example:

```
class Foo < ActiveRecord::Base
...
  def self.main_fields
    [:title, :price, :sale_date]
  end
end
``` 

###Methods

`ActiveAdminSimpleLife.for KlassName, [options]` which will make all dirty work, and just 
give you simple menu, with only `main_fields` and `filters` in 1 line.
method takes options like:
 * `:priority` = `ActiveAdmin` proxy menu `priority`
 * `:parent` = `ActiveAdmin` proxy menu `parent`
 * `:permitted_params` = addition for strong params (by default provides only 
 `main_fields`)
 * `:max_length` = max column length

Parts of `simple_menu_for` may be used for other purposes with:
* `index_for_main_fields klass, options`, where options are:
  1.   `:max_length` - max length of field. Integer
  2.    `:add`       - extra fields, which will be added in index. Symbol or Array
  3.    `:position`  - extra fields starting position (from 0)
* `filter_for_main_fields klass, options`
  1. `:options` - accept Hash of options for 1 column, like `products: { hint: 'click for select'}`
* `form_for_main_fields klass`

Other feature is simple menu with 1 single nested klass. For it I made
 * `nested_form_for_main_fields klass, nested_klass, options`
  1. `:options` - accept Hash of options for 1 column ot nested column. Nested column example
  `products: {comments: { label: 'Words'} }`

###Goodies

Added generator with simple settings model for future use. I find it reusable, 
so, you may like it. For installation run 

`rails g active_admin_simple_life:simple_config`

 * For :gender field in filers provided 'male' and 'female' names instead of yes/no

###I18n

For boolean data only

```
en:
  boolean:
    active: 'Active'
    not_active: 'Not active'
```

###PS:
After making this gem a found this 
[article](http://tmichel.github.io/2015/02/22/sharing-code-between-activeadmin-resources/),
it may be useful.
