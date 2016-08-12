# de-anonymization combine

### Getting Started
    $ git clone git@github.com:MihailSalnikov/Combine.git
    $ cd Combine
    $ bundle install
Change the settings in the config/config.yml
    
    vk_api_id: YOU_VK_APP_ID 
    domain: YOU_DOMAIN
Change the settings in the config / database.yml if needed
    
    default: &default
        adapter: postgresql
        encoding: unicode
        username: USER_NAME
...
    
    $ rake db:create
    $ rake db:migrate

##### Start the server on the local host
Add a local.host to /etc/hosts
    
    127.0.0.1	localhost

Start server

    $ rvmsudo bundle exec rackup config.ru -p 80

