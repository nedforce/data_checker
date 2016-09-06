# DataChecker

Checks AR objects for errors.

## Runner configuration

Example runner:

```ruby
class NodeCheckRunner < DataChecker::Runner
  models      Node
  checker     LinkChecker
  scope       lambda{|model| model.where('last_checked_at is null').any? ? model.where('last_checked_at is null') : model.reorder('last_checked_at asc') }
  select      lambda{|subject| !subject.offline }
  after_check lambda{|subject| subject.update_column :last_checked_at, Time.now }
end
```

* models: A model or array of models to run through the set of checkers
* checker: A checker that should be run on the given models. Can be specified multiple times.
* scope: A scope to use for the given model. The model itself is passed in.
* select: Can be used to specify whether a model instance should be checked or not after it has been loaded.
* after_check: Can be used to perform some tasks after checking
