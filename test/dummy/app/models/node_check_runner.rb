class NodeCheckRunner < DataChecker::Runner  
  models      Node
  checker     LinkChecker  
  after_check lambda{|subject| subject.update_column :last_checked_at, Time.now }  
end
