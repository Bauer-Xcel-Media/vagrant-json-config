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

By default, no data will be loaded and no error is raised, if a given files does not exsist. To change that behavior,
add true as the third parameter.

```ruby
Vagrant.configure("2") do |config|
  ...
  
  config.jsonconfig.load_json "config.json", nil, true 

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

Accessing data from the root attribute accessor 'data' is deprecated. Please use the ```get``` function as described
above.

## Loding multiple files

### Merging

Instead of merging multiple loded files to one source, the loaded files can be populated to different keys.

Given the following json files:

foo.json
```json
{
  "key": {
    "foo": "bar",
    "baz": "bee"
  }
}

```

bar.json
```json
{
  "key": {
    "boo": "foo"
  }
}

```

And loading them to the same source as described above 

```ruby
Vagrant.configure("2") do |config|
  ...

  config.jsonconfig.load_json "foo.json" 
  config.jsonconfig.load_json "bar.json"
   
  ...
end
```

Would merge the two objects, resulting in the following

```ruby
  ...
  
  config.jsonconfig.get "key"
  >> {
         "foo": "bar",
         "baz": "bee",
         "boo": "foo"    
     }
  ...
```

### Different sources

To load the config to different sources, do the following

```ruby
Vagrant.configure("2") do |config|
  ...

  config.jsonconfig.load_json "foo.json", "key", "foodata"
  config.jsonconfig.load_json "bar.json", "key", "bardata"
   
  ...
end
```

This will retrieve the data from both files under 'key' in different sources. These can be acessed via

```ruby
  ...
  
  config.jsonconfig.get "baz", "foodata"
  >> "bee"
  
  config.jsonconfig.get "boo", "bardata"
  >> "foo"
   
  ...
```


## Contributing

1. Fork it ( https://github.com/Bauer-Xcel-Media/vagrant-json-config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

