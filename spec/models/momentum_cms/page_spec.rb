require_relative '../../rails_helper'

describe MomentumCms::Page, 'Model' do
  before(:each) do
    I18n.locale = :en
    @page = create(:page)
    @page.reload

    @page_child = create(:page_child)
    @page_child.parent = @page
    @page_child.save
    @page_child.reload

    @page_grandchild = create(:page_grandchild)
    @page_grandchild.parent = @page_child
    @page_grandchild.save
    @page_grandchild.reload
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@page.valid?).to be true
      expect(@page_child.valid?).to be true
      expect(@page_child.parent).to eq(@page)
    end

    it 'should have unique identifier' do
      site = create(:site)

      expect { create(:page, identifier: 'foo', site: site) }.to change { MomentumCms::Page.count }.by(1)
      page = build(:page, identifier: 'foo', site: site)
      page.save
      expect(page.errors.include?(:identifier)).to be true
    end

    it 'should allow same identifier for different sites' do
      @page_1 = create(:page, identifier: 'foo', site: create(:site))
      expect(@page_1.valid?).to be true

      @page_2 = create(:page, identifier: 'foo', site: create(:site))
      expect(@page_2.valid?).to be true
    end

    it 'should not allow same identifier for same sites' do
      site = create(:site)

      @page_1 = create(:page, identifier: 'foo', site: site)
      expect(@page_1.valid?).to be true

      @page_2 = build(:page, identifier: 'foo', site: site)
      expect(@page_2.valid?).to be false
    end
  end

  context '.ancestor_and_self!' do
    it 'should get valid ancestry' do
      expect(MomentumCms::Page.ancestor_and_self!(@page)).to eq([@page])
      expect(MomentumCms::Page.ancestor_and_self!(@page_child)).to eq([@page, @page_child])
      expect(MomentumCms::Page.ancestor_and_self!(@page_grandchild)).to eq([@page, @page_child, @page_grandchild])
      expect(MomentumCms::Page.ancestor_and_self!(nil)).to eq([])
    end
  end

  context '.published' do
    it 'should only return published published pages' do
      @page.publish!
      expect(MomentumCms::Page.published).to include(@page)
    end
  end

  context '#unpublish!' do
    it 'should unset the published boolean flag' do
      @page.publish!
      expect(@page.published?).to be true

      @page.unpublish!
      expect(@page.published?).to be false
    end
  end

  context '#publish!' do
    it 'should set the published boolean flag' do
      @page.publish!
      expect(@page.published?).to be true
    end

    it 'should save fields' do
      10.times do
        @page.fields << create(:field)
      end
      @page.publish!

    end
  end

  context '#generate_path' do
    it 'should generate basic path' do
      page = create(:page, slug: 'about')
      expect(page.new_record?).to be false
      expect(page.path).to eq '/about'
    end

    it 'should translate path and locales' do
      @page.update_attributes({slug: 'default'})
      expect(I18n.locale).to be :en
      expect(@page.slug).to eq 'default'
      expect(@page.path).to eq '/default'

      I18n.locale = :fr
      @page.update_attributes({slug: 'le-test'})
      expect(I18n.locale).to be :fr
      expect(@page.slug).to eq 'le-test'
      expect(@page.path).to eq '/le-test'

      I18n.locale = :en
      expect(I18n.locale).to be :en
      expect(@page.slug).to eq 'default'
      expect(@page.path).to eq '/default'
    end

    it 'should assign nested path' do
      expect(@page.path).to eq '/page'
      expect(@page_child.path).to eq '/page/page-child'
      expect(@page_grandchild.path).to eq '/page/page-child/page-grandchild'
    end

    it 'should assigns correct translation paths' do
      expect(@page_grandchild.path).to eq '/page/page-child/page-grandchild'
      I18n.locale = :fr
      @page.update_attributes({slug: 'default-fr'})
      @page.reload
      @page_child.reload
      @page_grandchild.reload
      expect(@page.path).to eq '/default-fr'
      expect(@page_child.path).to eq '/default-fr/page-child'
      expect(@page_grandchild.path).to eq '/default-fr/page-child/page-grandchild'
      @page_child.update_attributes({slug: 'child-fr'})
      @page_child.reload
      @page_grandchild.reload
      expect(@page_child.path).to eq '/default-fr/child-fr'
      expect(@page_grandchild.path).to eq '/default-fr/child-fr/page-grandchild'
      @page_grandchild.update_attributes({slug: 'grandchild-fr'})
      @page_grandchild.reload
      expect(@page_grandchild.path).to eq '/default-fr/child-fr/grandchild-fr'
      I18n.locale = :en
      @page_grandchild.reload
      expect(@page_grandchild.path).to eq '/page/page-child/page-grandchild'
    end

    it 'should assigns fallback slugs to path when required' do
      # TODO: look deeper into globalize's fallback feature. Specifically, we
      # need the ability for site admins to set default locales for each site
      I18n.locale = :fr
      @page.update_attributes(slug: 'default-fr')
      @page_grandchild.update_attributes(slug: 'grandchild-fr')
      expect(@page.path).to eq '/default-fr'
      expect(@page_grandchild.path).to eq '/default-fr/page-child/grandchild-fr'
    end

    it 'should regenerate paths of child pages' do
      expect(@page_grandchild.path).to eq '/page/page-child/page-grandchild'
      # After updating the child slug, it should regenerate the grandchild
      @page_child.update_attributes({slug: 'new-slug'})
      expect(@page_child.path).to eq '/page/new-slug'
      expect(@page_child.slug).to eq 'new-slug'
      @page_grandchild.reload
      expect(@page_grandchild.path).to eq '/page/new-slug/page-grandchild'
      @page_grandchild.update_attributes({slug: 'new-grandchild-slug'})
      expect(@page_grandchild.path).to eq '/page/new-slug/new-grandchild-slug'
      @page_child.update_attributes({slug: 'another-slug'})
      expect(@page_child.path).to eq '/page/another-slug'
      expect(@page_child.slug).to eq 'another-slug'
      @page_grandchild.reload
      expect(@page_grandchild.path).to eq '/page/another-slug/new-grandchild-slug'
    end
  end
end
