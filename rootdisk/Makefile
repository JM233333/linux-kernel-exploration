## Check Required Parameters

ifeq ($(IMAGE),)
    $(error Error - $$IMAGE required to generate rootdisk image)
endif

ifneq ($(MAKECMDGOALS), clean)
ifeq ($(IMGTYPE),)
    $(error Error - $$IMGTYPE required to generate rootdisk image)
endif
endif

## Configurations

export DIR_MOUNT := $(realpath .)/disk

## Rules

gen:
	make -s -C $(IMGTYPE) gen IMAGE=$(notdir $(IMAGE))
	rm -f $(IMAGE)
	echo + ln -s $(IMGTYPE)/$(IMAGE) $(IMAGE)
	ln -s $(IMGTYPE)/$(IMAGE) $(IMAGE)

.PHONY: gen

## Rules : Clean

CLEAN_PREFIX   := __clean__
CLEAN_IMGTYPES := $(dir $(shell find . -name Makefile))
CLEAN_IMGTYPES := $(subst ./, $(CLEAN_PREFIX)/, $(filter-out ./, $(CLEAN_IMGTYPES)))

clean: $(CLEAN_IMGTYPES)
	rm -rf $(DIR_MOUNT)
	rm -f $(IMAGE)

$(CLEAN_IMGTYPES):
	echo + make -s -C $(subst $(CLEAN_PREFIX)/,,$@) clean
	make -s -C $(subst $(CLEAN_PREFIX)/,,$@) clean IMAGE=$(notdir $(IMAGE))

.PHONY: clean $(CLEAN_IMGTYPES)
