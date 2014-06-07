require_relative '../../rails_helper'

describe MomentumCms::Template do
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
      expect { @template.destroy }.to raise_error
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
