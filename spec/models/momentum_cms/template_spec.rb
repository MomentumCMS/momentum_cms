require_relative '../../rails_helper'

describe MomentumCms::Template, 'Model' do
  before(:each) do
    @template = create(:template)
    @template_child = create(:template_child)

    @template_child.parent = @template
    @template_child.save
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@template.valid?).to be true
      expect(@template_child.valid?).to be true
      expect(@template_child.parent).to eq(@template)
    end

    it 'should have unique identifier' do
      site = create(:site)

      expect { create(:template, identifier: 'foo', site: site) }.to change { MomentumCms::Template.count }.by(1)
      template = build(:template, identifier: 'foo', site: site)
      template.save
      expect(template.errors.include?(:identifier)).to be true
    end

    it 'should allow same identifier for different sites' do
      @template_1 = create(:template, identifier: 'foo', site: create(:site))
      expect(@template_1.valid?).to be true

      @template_2 = create(:template, identifier: 'foo', site: create(:site))
      expect(@template_2.valid?).to be true
    end

    it 'should not allow same identifier for same sites' do
      site = create(:site)

      @template_1 = create(:template, identifier: 'foo', site: site)
      expect(@template_1.valid?).to be true

      @template_2 = build(:template, identifier: 'foo', site: site)
      expect(@template_2.valid?).to be false
    end
  end

  context '.for_site' do
    it 'should only return Template for the given site' do
      expect(MomentumCms::Template.for_site(@template.site)).to include(@template)

      site = create(:site)
      expect(MomentumCms::Template.for_site(site)).to_not include(@template)
    end
  end

  context '.has_yield' do
    it 'should only return Templates with cms yield tag' do
      expect(MomentumCms::Template.has_yield).to include(@template)
    end

    it 'should not return Template without cms yield tag' do
      expect(MomentumCms::Template.has_yield).to_not include(@template_child)
    end
  end

  context '#ensure_can_delete_record' do
    it 'should not allow permanent record to be deleted' do
      @template.update_attributes({permanent_record: true})
      expect { @template.destroy }.to raise_error(MomentumCms::PermanentObject)
      expect(@template.persisted?).to be true
    end

    it 'should allow non permanent record to be deleted' do
      expect { @template.destroy }.to_not raise_error
    end
  end

  context '.ancestry_select' do
    it 'should return a tree in the proper tree order' do
      expect(MomentumCms::Template.ancestry_select).to eq([[" #{@template.label}", @template.id],
                                                           ["- #{@template_child.label}", @template_child.id]])
    end
  end

  context '.ancestor_and_self!' do
    it 'should get valid ancestry' do
      expect(MomentumCms::Template.ancestor_and_self!(@template)).to eq([@template])
      expect(MomentumCms::Template.ancestor_and_self!(@template_child)).to eq([@template, @template_child])
      expect(MomentumCms::Template.ancestor_and_self!(nil)).to eq([])
    end
  end

  context '#valid_liquid_value' do
    it 'should have a yield tag before it can act as a parent' do
      expect(@template.has_children?).to be true
      @template.value = 'parent'
      expect(@template.valid?).to be false
    end

    it 'should only allow valid liquid template as the value' do
      template = build(:template, value: '{{foo')
      expect(template.valid?).to be false
    end
  end
end
