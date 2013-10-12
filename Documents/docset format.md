Apple Xcode document use docset format store, user can use Xcode download all documents, soon as downloaded and these document will be placed at path /Applications/Xcode.app/Contents/Developer/Documentation/DocSets/.

Usualy these are servel files in this path, all have ext as .docset, these files are actruly directorys.

Directorys structure:

- Contents
	+ version.plist
	+ Info.plist
	+ Resources
		+ docSet.skidx
		+ docSet.toc
		+ docSet.dsidx
		+ docSet.tokencache
		+ Tokens
		+ Documents
		
docSet.toc is a plist file. 
	