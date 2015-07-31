[![Gem Version](https://badge.fury.io/rb/vagrant-json-config.svg)](http://badge.fury.io/rb/vagrant-json-config)

# Vagrant json config plugin

This is a simple Vagrant plugin that loads configuration variables from a json file to be able to dynamically configure
a vagrant machine without changing the actual Vagrantfile.

## Usage

Install using standard Vagrant plugin installation methods. 

```
$ vagrant plugin install vagrant-json-config
```

After installing, add a json file to the root of your project

```json
{
  "key": {
    "foo": "bar",
    "baz": "bee"
  }
}

```

Load it in the vagrant file

```ruby
Vagrant.configure("2") do |config|
  ...
  
  config.jsonconfig.load_json "config.json"

  ...
end
```

You may also use a different location. In that cas you will have to specify an absolute path.

If you only want a specific part of the data to be loaded, you may specify a key while loading the file

```ruby
Vagrant.configure("2") do |config|
  ...
  
  config.jsonconfig.load_json "config.json", ENV["PROJECT_KEY"] 

  ...
end
```


After that the defined variables can be accessed from the ```config.jsonconfig``` object like the following: 

```ruby
Vagrant.configure("2") do |config|
  ...
  
  config.vm.hostame = config.jsonconfig.get "foo" 

  ...
end
```

## Contributing

1. Fork it ( https://github.com/Bauer-Xcel-Media/vagrant-json-config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

