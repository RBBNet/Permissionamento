// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library Pagination {

    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    error InvalidArgument(string message);

    function getUintPage(EnumerableSet.UintSet storage set, uint pageNumber, uint pageSize) internal view returns(uint[] memory) {
        if(pageNumber < 1) {
            revert InvalidArgument("Page must be greater or equal to 1 ");
        }
        if(pageSize < 1) {
            revert InvalidArgument("Page size must be greater or equal to 1 ");
        }
        uint start = (pageNumber - 1) * pageSize;
        if(start > set.length()) {
            start = set.length();
        }
        uint stop = start + pageSize;
        if(stop > set.length()) {
            stop = set.length();
        }
        uint[] memory page = new uint[](stop - start);
        for(uint i = start; i < stop; ++i) {
            page[i - start] = set.at(i);
        }
        return page;
    }

    function getAddressPage(EnumerableSet.AddressSet storage set, uint pageNumber, uint pageSize) internal view returns(address[] memory) {
        if(pageNumber < 1) {
            revert InvalidArgument("Page must be greater or equal to 1 ");
        }
        if(pageSize < 1) {
            revert InvalidArgument("Page size must be greater or equal to 1 ");
        }
        uint start = (pageNumber - 1) * pageSize;
        if(start > set.length()) {
            start = set.length();
        }
        uint stop = start + pageSize;
        if(stop > set.length()) {
            stop = set.length();
        }
        address[] memory page = new address[](stop - start);
        for(uint i = start; i < stop; ++i) {
            page[i - start] = set.at(i);
        }
        return page;
    }

}