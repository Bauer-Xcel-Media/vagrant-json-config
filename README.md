# Vagrant JsonConfig plugin

This is a simple Vagrant plugin that loads configuration variables from a json file to be able to dynamically configure
a vagrant machine without changing the actual Vagrantfile.

## Usage

Install using standard Vagrant plugin installation methods. 

```
$ vagrant plugin install vagrant-json-config
```

After installing, add your application configuration to your projects.json file in the root of your project

```json
{
  "key": {
    "foo": "bar",
    "baz": "bee"
  }
}

```

After that the defined variables can be accessed from the ```config.jsonconfig``` key like the following: 

```
Vagrant.configure("2") do |config|
  ...
  
  config.vm.hostame = config.jsonconfig.project['foo'] 

  ...
end
```

To select the correct key fom the json file, the ```PROJECT_KEY``` environment variable has to be set:

```
$ PROJECT_KEY=key vagrant up
```

## Contributing

1. Fork it ( https://github.com/Bauer-Xcel-Media/vagrant-json-config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

