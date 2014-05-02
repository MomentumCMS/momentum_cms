# Momentum CMS

[![Build Status](https://travis-ci.org/MomentumCMS/momentum_cms.svg?branch=master)](https://travis-ci.org/MomentumCMS/momentum_cms) [![Code Climate](https://codeclimate.com/github/MomentumCMS/momentum_cms.png)](https://codeclimate.com/github/MomentumCMS/momentum_cms) [![Dependency Status](https://gemnasium.com/MomentumCMS/momentum_cms.png)](https://gemnasium.com/MomentumCMS/momentum_cms)

Get started:

```
git clone git@github.com:MomentumCMS/momentum_cms.git
cd momentum_cms/test/dummy
rake db:drop db:create momentum_cms_engine:install:migrations db:migrate && rake db:seed
rails s
```