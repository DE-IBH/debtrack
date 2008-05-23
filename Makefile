clean:
	

install:
	mkdir -p $(DESTDIR)/usr/lib/debtrack
	for i in debcheckpoint.sh debdiff.sh debupdatecheck.sh kernelinfo.sh show-tech-support.sh; do \
	    cp "$$i" $(DESTDIR)/usr/lib/debtrack; \
	done
	
	mkdir -p $(DESTDIR)/var/lib/debtrack
	cp cp/* $(DESTDIR)/var/lib/debtrack
	
	mkdir -p $(DESTDIR)/usr/sbin
	cp debtrack $(DESTDIR)/usr/sbin
