publish: import
	(hugo; cd public/; git add *; git commit -a -m "update"; git push)

import:
	cat source/workflow-discovery/README.md > content/docs/guide.md 
	cat source/workflow-discovery/README.md > content/_index.md
