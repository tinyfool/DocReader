DocReader
=========
DocReader is a apple DocSet format document reader(see also in DocumentationSets.pdf). Apple use this format as standard document format of Xcode developmemnt tool since Xcode 3.0. 

We make DocReader beacause since Xcode 5, buildin document reader contain so many bugs. At first version,  document reader did not contain topic navigation cloumn, so you can only search topic to read. After Xcode 5.0.1, buildin document reader finally have topic navigation cloumn, but only some topic can be select.

Dash(http://kapeli.com/dash) and some other tools can be use to read Xcode document also. But Dash not design for read DocSet format, it can not navigate topic tree aslo. We beleive there is two method to read document. "Navigating by topic struct" And "Searching topic to read", this two method both very useful to developers.

So, we decide to make a fast, easy use, full funcitonal apple DocSet format document reader.

## Features

* Support apple DocSet format document (maybe not compatible with some very old version).
* Full support navigating by topic tree.
* Keyword search.
* Look up word from system dictionary, speak it by sytem tts.
* Reader support navigation history.
