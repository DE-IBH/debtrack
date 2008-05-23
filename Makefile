clean:
	

install:
	mkdir -p $(DESTDIR)/usr/lib/debtrack
	for i in debcheckpoint.sh debdiff.sh debupdatecheck.sh kernelinfo.sh show-tech-support.sh debtrack.sh; do \
	    cp "$$i" $(DESTDIR)/usr/lib/debtrack; \
	done
	
	mkdir -p $(DESTDIR)/var/lib/debtrack
	cp cp/* $(DESTDIR)/var/lib/debtrack
	
	mkdir -p $(DESTDIR)/usr/sbin
	cp debtrack $(DESTDIR)/usr/sbin
	
	mkdir -p $(DESTDIR)/etc/apt/apt.conf.d
	cp 99debtrack $(DESTDIR)/etc/apt/apt.conf.d
	cp debtrack.conf $(DESTDIR)/etc
