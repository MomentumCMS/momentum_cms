# Momentum CMS

Get started:

```
git clone git@github.com:MomentumCMS/momentum_cms.git
cd momentum_cms/test/dummy
rake db:drop db:create momentum_cms_engine:install:migrations db:migrate && rake db:seed
rails s
```