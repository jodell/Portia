
require File.expand_path(File.dirname(__FILE__)) + '/../wtf'
require 'test/unit'

class WTFTest < Test::Unit::TestCase
  include WTF

  def setup
    @s = Site.new(File.expand_path(File.dirname(__FILE__)) + '/../var/cashnetusa.com/cashnetusa.com.yml')
  end

  def teardown
  end

  def test_identity
    assert_raise ArgumentError do Site.new end
    assert @s.pages.is_a?(Array)
    @s.pages.each { |p| assert p.is_a?(Page) }
    [:site, :pages, :transitions].each do |a| 
      assert @s.respond_to?(a), "#{a} is not an attribute!"  
    end
  end

  def test_cnu
    assert @s.send(:homepage).is_a?(Page)
    assert @s.homepage.is_a?(Page)
    [:all, :links].each do |m| 
      assert @s.homepage.send(m).is_a?(Hash), "#{@s.homepage.send(m).class}"
    end
    assert @s.homepage.links.is_a?(Hash)
    assert @s['homepage'].names.is_a?(Array)
    assert @s.homepage == @s.home
    assert @s['homepage'].is_a?(Page)
    assert @s['homepage'] == @s['home']
    assert @s[0].is_a?(Page)
    assert @s[0] == @s['home']
    assert @s.root.is_a?(Page)
    assert @s.root.links.nil?
    assert @s.root.text_boxes
    assert @s.root.text_boxes
    assert @s.root.input
    assert @s.contract
    assert @s.contract.i_agree
    assert @s.us_contract
  end

  def test_page_generator
    assert @pg = WTF::PageGenerator.new
  end

end
