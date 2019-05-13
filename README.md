# TreeCanvasView

![Alt text](screenshots/TreeCanvasViewDemo.gif?raw=true "TreeCanvasView Demo")

A tree style table view written in Swift, with parent and children data structure included! 😃  
Each `TreeCanvasView`'s row is either parent or child (or both). It means Adding a row and data to the table requires relationship.  
And after rows are set and relationships are created, `TreeCanvasView` will act like real tree structure on table UI.  
(Something like adding child, sibling, or moving with children, as well as delete)  
This is just an earlier version for my other project, so feel free to ask. Thanks!


## Getting Started


### Prerequisites
Same or higher version of `iOS 11` is absolutely required.  
Running on `Xcode 10.2 & Swift5`; Lower version is not tested.  
No other special prerequisites for this.


### Installing

1. Install with cocoapod on your root project folder on terminal.
```
pod init
```

2. open `Podfile` and add this line below `use_frameworks!`.

```
pod 'TreeCanvasView', :git => 'https://github.com/shmruin/TreeCanvasView.git', :tag => '1.0.1'
```

3. Save and exit, type below.

```
pod install
```

4. Open your project and see if this framework is adjusted correctly!

## How to use

If you put the data on correct position, it will show on TreeCanvasView.  
See the example below.

### Declaration of TreeCanvasView

1. Easiest way to make TreeCanvasView is `drawing a table view on storyboard`.  
`Set its class and module with TreeCanvasView` on Custom Class Tab.

2. After the works on storyboard, go to the controller you set the TreeCanvasView.  
Make outlet with TreeCanvasView. Then TreeCanvasView will automatically linked on the table view.
```
@IBOutlet weak var tableCanvas: TreeCanvasView!
```
### Set initial Data

1. You have to set initial data of TreeCanvasView.  
Even if it is not the case, **TreeCanvasView will empty and Root node of ID 0** will be set as default.

2. Set your initial data for table.  
In `viewDidLoad` of your controller: something like below (just an example)

```
let nodeDataArr1 = ["Meet Harris today... 1", "Buy an awesome book... 2", "Prepare Math exam... 3"]
let nodeDataArr2 = ["Where should I meet him?... 1", "Preparation?... 2", "Topics?... 3"]
let nodeDataArr3 = ["Chapter 1 to 5... 1"]
let nodeDataArr4 = ["Get some advice about health... 1", "Small talks... 2"]
let nodeDataArr5 = ["At Zubrovka cafe... 1"]
```

and another lines followed.
```
_ = tableCanvas.addNodesToParent(nodeDataArr1, 0)
_ = tableCanvas.addNodesToParent(nodeDataArr2, 1)
_ = tableCanvas.addNodesToParent(nodeDataArr3, 3)
_ = tableCanvas.addNodesToParent(nodeDataArr4, 6)
_ = tableCanvas.addNodesToParent(nodeDataArr5, 4)
```

Now you get some ideas. Each arrays mean layer data. We declare them as the first factor.  
And then you can `addNodesToParent(DataArray, NodeID)`. Node ID is a unique ID that starts from 0.  
(0 is already taken by the root)  
So you add the `nodeDataArr1` to the root, which will be first layer of the table.  
And `nodeDataArr2` follows as the children of `Node ID 1` (which is "Meet Harris today... 1"), and so on.  
  
  
**The text result is like this.**
```
ID: 1, Layer: 1, IsShow: true, Value: Meet Harris today... 1
  ⌞ID: 4, Layer: 2, IsShow: true, Value: Where should I meet him?... 1
   ⌞ID: 10, Layer: 3, IsShow: true, Value: At Zubrovka cafe... 1
  ⌞ID: 5, Layer: 2, IsShow: true, Value: Preparation?... 2
  ⌞ID: 6, Layer: 2, IsShow: true, Value: Topics?... 3
   ⌞ID: 8, Layer: 3, IsShow: true, Value: Get some advice about health... 1
   ⌞ID: 9, Layer: 3, IsShow: true, Value: Small talks... 2
ID: 2, Layer: 1, IsShow: true, Value: Buy an awesome book... 2
ID: 3, Layer: 1, IsShow: true, Value: Prepare Math exam... 3
  ⌞ID: 7, Layer: 2, IsShow: true, Value: Chapter 1 to 5... 1
```

These data will be gracefully shown on the table view (only the value).


### Custom settings

You can set some features if you want.  
But as this is an early version, there's only few.  

1. **setLayerSeperatorType**  
This is a feature function that is used to differ each layers.  
Two types : `fontSize` & `indent` - Each layer will have different font size and indent.
And it should be set inside `viewDidLoad()`. Try yourself!

* layerSeperatorType : `LayerSperatorType.fontSize` **OR** `LayerSperatorType.indent`
* headLevel : First layer's value
* diffLevel : The difference between the layers
* limitLevel : Minimal(Or Maximum) of the seperator level

```
setLayerSeperatorType(_ layerSeperatorType: LayerSperatorType, _ headLevel: Double, _ diffLevel: Double, _ limitLevel: Double)
```

Demo:
```
tableCanvas.setLayerSeperatorType(LayerSperatorType.fontSize, 20.0, 2.0, 10.0)
tableCanvas.setLayerSeperatorType(LayerSperatorType.indent, 0.0, 2.0, 6.0)
```

### Other utils

Some useful things for developer.

1. **printCurrentTreeCanvasView**  
Print current TreeCanvasView as text format. You already see this above.
You can see this on debug terminal.

Demo:
```
tableCanvas.printCurrentTreeCanvasView()
```

Result:
```
ID: 1, Layer: 1, IsShow: true, Value: Meet Harris today... 1
  ⌞ID: 4, Layer: 2, IsShow: true, Value: Where should I meet him?... 1
   ⌞ID: 10, Layer: 3, IsShow: true, Value: At Zubrovka cafe... 1
  ⌞ID: 5, Layer: 2, IsShow: true, Value: Preparation?... 2
  ⌞ID: 6, Layer: 2, IsShow: true, Value: Topics?... 3
   ⌞ID: 8, Layer: 3, IsShow: true, Value: Get some advice about health... 1
   ⌞ID: 9, Layer: 3, IsShow: true, Value: Small talks... 2
ID: 2, Layer: 1, IsShow: true, Value: Buy an awesome book... 2
ID: 3, Layer: 1, IsShow: true, Value: Prepare Math exam... 3
  ⌞ID: 7, Layer: 2, IsShow: true, Value: Chapter 1 to 5... 1
```

2. printCurrentRegisteredTreeCanvasNode  
A less useful, but important inspect function.  
It will print the current Node IDs that remains on TreeCanvasView: including Node ID 0, which is the root node.  
(But root node is not shown on table view, as I said)  
If you don't delete a node yet, The IDs are somewhat mixed numbers from 0.

Demo:
```
tableCanvas.printCurrentRegisteredTreeCanvasNode()
```

Result:
```
TreeCanvasNode IDs : 0 6 7 4 9 2 10 5 1 3 8 
```


## Manipulation for users

### Add a row's sibling or child 
- **swipe right** and select `sibling` or `child`
- when popup shows, write the value and set the direction (above/under)
- Confirm to adjust

### Delete a row
- **swipe left** and select `delete`

### Expand / Collapse a row
- **tap** the row
- It will collapse all the children or expand the direct children

### Move a row
- **long press** the row for a moment
- floating row animation will be shown
- the possible movement area will be fulfilled as green area (**same layer level**)
- drag the selected row to the area you want
- Rows will be swapped after ease

### Modify the value
- **double tab** the row to modify value of the raw
- A popup will appear and you can change the value to anything you want

## Built With

`No depenencies` with other library or framework.

## Contributing

Any Pull Request is fine, if it make sense and fully commented! 😝

## Versioning

1.0.1

## Authors

* **shmruin** - *Initial work* - [Personal Blog](http://finemoment.egloos.com/)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

