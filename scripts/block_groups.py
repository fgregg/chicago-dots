import json
import logging
import sys
import os

from census_area import Census

logging.basicConfig(level=logging.DEBUG)

c = Census(os.environ["CENSUS_API_KEY"])
chicago = c.acs5.state_place_blockgroup(("NAME",), 17, 14000, return_geometry=True)

json.dump(chicago, sys.stdout)
