class NodeCheckRunner < DataChecker::Runner  
  models      Node
  checker     LinkChecker
  scope       lambda{|model| model.where('last_checked_at is null').any? ? model.where('last_checked_at is null') : model.reorder('last_checked_at asc') }
  after_check lambda{|subject| subject.update_column :last_checked_at, Time.now }  
end
