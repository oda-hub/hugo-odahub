publish: 
	( \
		hugo && \
		cp public/ontology/index-en.html public/ontology/index.html && \
		rm -rfv oda-hub.github.io && \
		git clone https://mmoda-bot@github.com/oda-hub/oda-hub.github.io/&& \
		rsync -av public/ oda-hub.github.io/ && \
		cd oda-hub.github.io/ && \
	    git add * && \
		git commit -a -m "update" && \
		git push)



import:
	#cat source/workflow-discovery/README.md > content/docs/guide-discovery.md 
	#cat source/doc-issue-handling-workflow/README.md > content/docs/issues.md
	#cat source/guide-to-create-workflows/README.md > content/docs/guide-development.md


.FORCE:

ontology-from-webprotege:
	curl "https://webprotege.obsuks1.unige.ch/download?project=$$(pass oda/webprotege/projectid)&format=ttl" > ontology.zip
	cp ontology/ontology.ttl ontology/ontology.ttl.backup || touch ontology/ontology.ttl
	cat ontology/ontology-base.ttl > ontology/ontology.ttl
	unzip -p ontology.zip | sed 's@urn:webprotege:ontology:[0-9a-z\-]*@http://odahub.io/ontology@g' >> ontology/ontology.ttl


ontology: .FORCE
	git clone https://github.com/oda-hub/ontology/
	< ontology/ontology.ttl sed 's/owl:versionIRI ".*"/owl:versionIRI "'$(shell cd ontology; git describe --always --tags)'"/' > ontology/ontology-versionned.ttl
	mv -fv ontology/ontology-versionned.ttl ontology/ontology.ttl 
	# (cd ontology; git commit -a -m "update version"; git push)
	diff ontology/ontology.ttl ontology/ontology.ttl.backup || echo "an update happened!"
	python -m pip install rdflib
	python -c 'import rdflib; print("valid ontology with entries:", len(rdflib.Graph().parse(open("ontology/ontology.ttl"), format="turtle")))'

ontology/ontology-platforms.ttl: .FORCE
	curl "https://webprotege.obsuks1.unige.ch/download?project=$$(pass oda/webprotege/platforms-projectid)&format=ttl" > ontology.zip
	unzip -p ontology.zip | sed 's@urn:webprotege:ontology:[0-9a-z\-]*@http://odahub.io/ontology@g' >> ontology/ontology-platforms.ttl
	python -c 'import rdflib; print("valid ontology with entries:", len(rdflib.Graph().load(open("ontology/#ontology-platforms.ttl"), format="turtle")))'


# ontology: ontology/ontology.ttl
ontology-web:
	TDIR=$$(mktemp -d --suffix widoco) && cd $$TDIR && \
	wget -q -c -O /tmp/widoco.jar https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-17-widoco-1.4.17-jar-with-dependencies.jar; \
	java -jar /tmp/widoco.jar \
		-ontFile $$OLDPWD/ontology/ontology.ttl \
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

public/oda-sites.ttl: .FORCE
	curl https://www.astro.unige.ch/mmoda/dispatch-data/gw/odakb/query -d query='prefix oda: <http://odahub.io/ontology#>  CONSTRUCT WHERE {?a a <http://odahub.io/ontology#MMODASite>; ?b ?c . }' > public/oda-sites.ttl
