#ActiveAdminSimpleLife

About

Gem automatize routine with creation simple menus in ActiveAdmin with minimum 
code duplication. 

###Installation

put in `Gemfile` 

`gem 'active_admin_simple_life'`

in `config/initializers/active_admin.rb` change header like this:

```
# frozen_string_literal: true
include ActiveAdminSimpleLife
ActiveAdmin.setup do |config|
  include ActiveAdminSimpleLife::SimpleElements
  # your settings
```

I had to include `simple_menu_for` method bacause it must be in the main 
namespace, so it is not a bug ;)

###Usage

For all gem methods you need to present class method(NOT scope!) `main fields`, 
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

`simple_menu_for KlassName, [options]` which will make all dirty work, and just 
give you simple menu, with only `main_fields` and `filters` in 1 line.
method takes options like:
 * `:priority` = `ActiveAdmin` proxy menu `priority`
 * `:parent` = `ActiveAdmin` proxy menu `parent`
 * `:permitted_params` = addition for strong params (by default provides only 
 `main_fields`)
 * `:max_length` = max column length

Parts of `simple_menu_for` may be used for other purposes with:
* `index_for_main_fields klass, options`, where options is `:max_length`
* `filter_for_main_fields klass`
* `form_for_main_fields klass`

Other feature is simple menu with 1 single nested klass. For it I made
 * `nested_form_for_main_fields klass, nested_klass`

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
