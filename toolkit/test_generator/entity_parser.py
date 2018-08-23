## @file
## @brief VHDL entity parser.

import re

from entity import *

## @brief Matches all the documented libs.
## @details Gets all the doxygen doc/library statement pairs.
## @details Allows for using entity types in testbench.
r_lib = r'(--!.*\n*(library|use).*?;)'

## @brief Matches the entity name.
## @details /entity (name) is/
r_name = r'entity\s*([\w\d]*)\s*is'

## @brief Matches all the generic declarations.
## @details /(generic)_g : (type) := (default) (--!doc)/
## @details Requires _g suffix to be used only and in all generics.
## @details Requires a default value.
## @details Requires the generic declaration to be documented with doxygen.
r_generic = r'([\w\d]+)_g\s*:\s*(.*?)\s*:=\s*([0-9a-zA-Z_"]+);?\s*(--!.*)'

## @brief Matches all the entity port declarations.
## @details /(port) : (in|out) (type); (--!doc)/
## @details Only supports in|out port types.
## @details Requires the port declaration to be documented with doxygen.
r_port = r'([\w\d]+)\s*:\s*(in|out|buffer)\b\s*(.*?);?\s*(--!.*)'

## @brief Takes in a VHDL source and returns entity information.
## @details Only supports files with a single entity declaration.
## @return Entity object with parsed data.
def parse(source):
    # Searches the source for the entity name.
    name = re.search(r_name, source).group(1)

    # Searches the source for all generic declarations.
    generic_info = re.findall(r_generic, source)
    # Searches the source for all port declarations.
    port_info = re.findall(r_port, source)

    # Constructs a list of generic objects with the parsed generic declarations.
    generics = []
    for g in generic_info:
        generics.append(Generic(g[0] + '_g', g[1], g[2], g[3]))

    # Constructs a list of port objects with the parsed port declarations.
    ports = []
    for s in port_info:
        # Replaces generic definitions in port declarations (if they exist).
        port_type = s[2]
        for g in generics:
            port_type = port_type.replace(g.name, g.default)

        ports.append(Port(s[0], s[1], port_type, s[3]))

    # Constructs a list with the used libraries' declarations.
    libs = [group[0] for group in re.findall(r_lib, source)]
    return Entity(name, ports, generics, libs)
