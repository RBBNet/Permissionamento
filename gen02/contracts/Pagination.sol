// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library Pagination {

    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    error InvalidPaginationParameter(string message);

    function getUintPage(EnumerableSet.UintSet storage set, uint pageNumber, uint pageSize) internal view returns(uint[] memory) {
        (uint start, uint stop) = getPageBounds(set.length(), pageNumber, pageSize);
        uint[] memory page = new uint[](stop - start);
        for(uint i = start; i < stop; ++i) {
            page[i - start] = set.at(i);
        }
        return page;
    }

    function getAddressPage(EnumerableSet.AddressSet storage set, uint pageNumber, uint pageSize) internal view returns(address[] memory) {
        (uint start, uint stop) = getPageBounds(set.length(), pageNumber, pageSize);
        address[] memory page = new address[](stop - start);
        for(uint i = start; i < stop; ++i) {
            page[i - start] = set.at(i);
        }
        return page;
    }

    function getPageBounds(uint length, uint pageNumber, uint pageSize) internal pure returns (uint, uint) {
        if(pageNumber < 1) {
            revert InvalidPaginationParameter("Page must be greater or equal to 1 ");
        }
        if(pageSize < 1) {
            revert InvalidPaginationParameter("Page size must be greater or equal to 1 ");
        }
        uint start = (pageNumber - 1) * pageSize;
        if(start > length) {
            start = length;
        }
        uint stop = start + pageSize;
        if(stop > length) {
            stop = length;
        }
        return (start, stop);
    }

}