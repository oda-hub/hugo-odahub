		#mkdir -pv ontology; \
		#cat ../../renku/owl-doc/odaowl-static.html > ontology/index.html; \
		#cat ../../renku/owl-doc/rdf.ttl > ontology/rdf.ttl; \
		#rsync -avu ../../renku/owl-doc/lode/ ontology/lode/; \
		#mkdir -pv ontology-respec; \
		#cat ../source/odahub-respec/spec.html > ontology-respec/index.html; \
		#cat ../source/odahub-respec/rdf > ontology-respec/rdf; 
publish: import
	( \
		hugo; \
		cd public/; \
		cp ontology/index-en.html ontology/index.html ; \
	       	git add *; \
		git commit -a -m "update"; \
		git push)


import:
	cat source/workflow-discovery/README.md > content/docs/guide-discovery.md 
	cat source/workflow-discovery/README.md > content/_index.md
	cat source/doc-issue-handling-workflow/README.md > content/docs/issues.md
	cat source/guide-to-create-workflows/README.md > content/docs/guide-development.md


ontology:
	TDIR=$$(mktemp -d --suffix widoco) && cd $$TDIR && \
	wget -c -O /tmp/widoco.jar https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-17-widoco-1.4.17-jar-with-dependencies.jar; \
	< $$OLDPWD/ontology.ttl sed 's@urn:webprotege:ontology:[0-9a-z\-]*@http://odahub.io/ontology@g' > ontology.ttl && \
	java -jar /tmp/widoco.jar \
		-ontFile $$PWD/ontology.ttl \
		-outFolder $$OLDPWD/public/ontology \
		-oops \
		-getOntologyMetadata \
		-rewriteAll \
		-webVowl \
		-licensius \
		-includeAnnotationProperties \
		-uniteSections && \
	cp $$OLDPWD/public/ontology/index-en.html $$OLDPWD/public/ontology/index.html ; \
	echo "do!" && \
	echo rm -rfv $$TDIR
