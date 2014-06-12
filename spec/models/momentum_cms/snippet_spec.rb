require_relative '../../rails_helper'

describe MomentumCms::Snippet, 'Model' do
  before(:each) do
    @snippet = create(:snippet)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@snippet.valid?).to be true
    end

    it 'should have unique identifier' do
      site = create(:site)
      expect { create(:snippet, identifier: 'foo', site: site) }.to change { MomentumCms::Snippet.count }.by(1)
      site = build(:snippet, identifier: 'foo', site: site)
      site.save
      expect(site.errors.include?(:identifier)).to be true
    end
  end

  context '#assign_identifier' do
    it 'should assign identifier to snippet with label' do
      snippet = create(:snippet, identifier: nil, label: 'label')
      expect(snippet.valid?).to be true
      expect(snippet.persisted?).to be true

      snippet = build(:snippet, identifier: nil, label: nil)
      expect(snippet.valid?).to be false
      expect(snippet.persisted?).to be false
    end
  end

  context '#validate_value_does_not_nest' do
    it 'should allow plain text' do
      @snippet.value = 'foobar'
      expect(@snippet.valid?).to be true
    end

    it 'should not allowed invalid liquid tags' do
      @snippet.value = '{{foobar'
      expect(@snippet.valid?).to be false
      expect(@snippet.errors.include?(:value)).to be true
    end

    it 'should not allowed nested snippet tags' do
      @snippet.value = '{% cms_snippet identifier:foo %}'
      expect(@snippet.valid?).to be false
      expect(@snippet.errors.include?(:value)).to be true
    end
  end
end
