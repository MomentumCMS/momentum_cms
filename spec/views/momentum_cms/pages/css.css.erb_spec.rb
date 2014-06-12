require_relative '../../../rails_helper'

describe 'momentum_cms/pages/css.css.erb', 'View' do
  before(:each) do
    @site = create(:site, host: 'test.host')

    @template = create(:template, site: @site)

    @template_child = create(:template_child, site: @site)
    @template_child.parent = @template
    @template_child.save

    @template_array = [@template, @template_child]
  end

  it 'should render css correctly if there are templates' do
    assign(:template_array, @template_array)
    render template: 'momentum_cms/pages/css.css.erb', format: 'css'
    expect(rendered).to eq ".default{}\n.child{}\n"
  end

  it 'should render blank css if there are no templates' do
    assign(:template_array, [])
    render template: 'momentum_cms/pages/css.css.erb', format: 'css'
    expect(rendered).to eq ''
  end

  it 'should render blank css when nil is used' do
    assign(:template_array, nil)
    render template: 'momentum_cms/pages/css.css.erb', format: 'css'
    expect(rendered).to eq ''
  end
end
