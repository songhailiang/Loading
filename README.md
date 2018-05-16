# Loading
A top most indicator view written in Swift 4.

## Features
- Top most: Over UIAlertController and UIAlertView
- Force to hide when time out, allow to disable.
- Custom style.

## Usage
- Configuration(optional)
```
var config = LoadingConfig()
config.width = 60
config.radius = 8
config.style = .whiteLarge
config.backgroundColor = UIColor.lightGray
config.color = .red
config.maxUnlockTime = 0
Loading.config(config)
```

- Show
```
Loading.show()
```

- Hide
```
Loading.hide()
```

## Screen shots
<img src="https://github.com/songhailiang/Loading/blob/master/loading.gif" width="320" />
