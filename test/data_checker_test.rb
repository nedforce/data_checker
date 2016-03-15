require 'test_helper'

class DataCheckerTest < ActiveSupport::TestCase

  test 'link checker should find non existing links' do
    node = Node.create!(title: 'test', body: 'This is a non existing <a href="http://www.google.com/404me">link</a>', body2: 'OK')

    assert_difference 'DataChecker::DataWarning.count' do
      LinkChecker.new.apply node
    end

    warning = DataChecker::DataWarning.first
    assert_equal 'invalid_link', warning.error_code
    assert warning.message.include?('http://www.google.com/404me')
    assert warning.message.include?('HTTP 404')
  end

  test 'link checker should find invalid links' do
    node = Node.create!(title: 'test', body: 'This is an invalid <a href="htp://www.dewfgreghre.cdwm">link</a>', body2: 'OK')

    assert_difference 'DataChecker::DataWarning.count' do
      LinkChecker.new.apply node
    end

    warning = DataChecker::DataWarning.first
    assert_equal 'invalid_link', warning.error_code
    assert warning.message.include?('htp://www.dewfgreghre.cdwm')
    assert warning.message.include?('HTTP 404')
  end

  test 'link checker should find invalid links on all text columns' do
    node = Node.create!(title: 'test', body: 'This is an invalid <a href="htp://www.dewfgreghre.cdwm">link</a>', body2: 'This is a non existing <a href="http://www.google.com/404me">link</a>')

    assert_difference 'DataChecker::DataWarning.count', 2 do
      LinkChecker.new.apply node
    end

    DataChecker::DataWarning.all.each do |warning|
      assert_equal node, warning.subject
      assert_equal 'invalid_link', warning.error_code
    end
  end

  test 'link checker should find invalid links on all defined content columns' do
    Node.expects(:checker_columns).once().returns(:body)
    node = Node.create!(title: 'test', body: 'This is an invalid <a href="htp://www.dewfgreghre.cdwm">link</a>', body2: 'This is a non existing <a href="http://www.google.com/404me">link</a>')

    assert_difference 'DataChecker::DataWarning.count' do
      LinkChecker.new.apply node
    end

    warning = DataChecker::DataWarning.first
    assert warning.message.include?('htp://www.dewfgreghre.cdwm')
  end

  test 'should run all defined checkers on all defined models' do
    node1 = Node.create!(title: 'test', body: 'Nothing wrong with this node')
    node2 = Node.create!(title: 'test', body: 'This is a non existing <a href="http://www.google.com/404me">link</a>')
    node3 = Node.create!(title: 'test2', body: 'This is an invalid <a href="htp://www.dewfgreghre.cdwm">link</a>')

    assert NodeCheckRunner.run!

    assert DataChecker::DataWarning.all.detect{|warning| warning.subject == node1 }.nil?
    assert warning1 = DataChecker::DataWarning.all.detect{|warning| warning.subject == node2}
    assert warning2 = DataChecker::DataWarning.all.detect{|warning| warning.subject == node3}

    assert warning1.message.include?('http://www.google.com/404me')
    assert warning2.message.include?('htp://www.dewfgreghre.cdwm')
  end

  test 'should set the last checked timestamp' do
    node = Node.create!(title: 'test', body: 'Nothing wrong with this node')

    assert node.last_checked_at.blank?
    assert NodeCheckRunner.run!
    assert node.reload.last_checked_at.present?
  end

  test 'should write to the rails logger' do
    DataChecker.stubs(:logger).returns(DataChecker::RailsLogger.new)

    assert DataChecker.logger.is_a?(DataChecker::RailsLogger)
    DataChecker.logger.expects(:warn).once().returns(true)

    node = Node.create!(title: 'test', body: 'This is a non existing <a href="http://www.google.com/404me">link</a>')

    assert NodeCheckRunner.run!
    assert node.reload.last_checked_at.present?
  end

  test 'should not report the same error twice' do
    node = Node.create!(title: 'test', body: 'This is a non existing <a href="http://www.google.com/404me">link</a>', body2: 'OK')

    assert_difference 'DataChecker::DataWarning.count' do
      LinkChecker.new.apply node
    end

    assert_no_difference 'DataChecker::DataWarning.count' do
      LinkChecker.new.apply node
    end
  end
end
