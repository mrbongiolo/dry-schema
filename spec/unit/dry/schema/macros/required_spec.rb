require 'dry/schema/macros/required'

RSpec.describe Dry::Schema::Macros::Required do
  subject(:macro) do
    Dry::Schema::Macros::Required.new(:email)
  end

  describe '#to_rule' do
    it 'builds a valid rule without additional predicates' do
      rule = macro.to_rule

      expect(rule.(email: "jane@doe.org")).to be_success
      expect(rule.(imejl: "jane@doe.org")).to be_failure
    end

    it 'builds a valid rule with additional predicates' do
      rule = macro.value(:str?, size?: 2..20).to_rule

      expect(rule.(email: "jane@doe.org")).to be_success

      expect(rule.(imejl: "jane@doe.org")).to be_failure
      expect(rule.(email: "j")).to be_failure
      expect(rule.(email: "jane@doe.org"*2)).to be_failure
    end
  end

  describe '#filled' do
    it 'builds a rule with :filled? predicate without additional predicates' do
      rule = macro.filled.to_rule

      expect(rule.(email: "jane@doe.org")).to be_success
      expect(rule.(email: "")).to be_failure
      expect(rule.(email: nil)).to be_failure
    end

    it 'builds a valid rule with additional predicates' do
      rule = macro.filled(:str?).to_rule

      expect(rule.(email: "jane@doe.org")).to be_success
      expect(rule.(email: "")).to be_failure
      expect(rule.(email: 312)).to be_failure
    end
  end
end
