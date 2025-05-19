const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Pagination Library", function () {
  let paginationMock;

  beforeEach(async function () {
    const PaginationMock = await ethers.getContractFactory("PaginationMock");
    paginationMock = await PaginationMock.deploy();
    await paginationMock.waitForDeployment(); 
  });

  describe("getPageBounds()", function () {
    it("should revert if pageNumber is 0", async function () {
      await expect(
        paginationMock.getTestPageBounds(10, 0, 5)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should revert if pageSize is 0", async function () {
      await expect(
        paginationMock.getTestPageBounds(10, 1, 0)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should return (0,0) if start >= totalItems", async function () {
      const [start, stop] = await paginationMock.getTestPageBounds(5, 10, 5);
      expect(start).to.equal(0);
      expect(stop).to.equal(0);
    });

    it("should calculate correct bounds", async function () {
      const [start, stop] = await paginationMock.getTestPageBounds(20, 2, 5);
      expect(start).to.equal(5);
      expect(stop).to.equal(10);
    });

    it("should adjust stop if it exceeds totalItems", async function () {
      const [start, stop] = await paginationMock.getTestPageBounds(12, 3, 5);
      expect(start).to.equal(10);
      expect(stop).to.equal(12);
    });
  });

  describe("getUintPage()", function () {
    beforeEach(async function () {
      for (let i = 1; i <= 10; i++) {
        await paginationMock.addUintToTestSet(i);
      }
    });

    it("should revert if pageNumber is 0", async function () {
      await expect(
        paginationMock.getUintTestPage(0, 5)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should revert if pageSize is 0", async function () {
      await expect(
        paginationMock.getUintTestPage(1, 0)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should return correct page of uints", async function () {
        const page = await paginationMock.getUintTestPage(2, 3);
        const numbers = page.map(p => p.toNumber ? p.toNumber() : p); 
        expect(numbers).to.deep.equal([4, 5, 6]);
    });

    it("should return empty array if startIndex >= totalElements", async function () {
        const page = await paginationMock.getUintTestPage(5, 10);
        const numbers = page.map(p => p.toNumber ? p.toNumber() : p);
        expect(numbers.length).to.equal(0);
    });

    it("should adjust endIndex if it exceeds totalElements", async function () {
        const page = await paginationMock.getUintTestPage(4, 3);
        const numbers = page.map(p => p.toNumber ? p.toNumber() : p);
        expect(numbers).to.deep.equal([10]);
    });
  });

  describe("getAddressPage()", function () {
    beforeEach(async function () {
      const signers = await ethers.getSigners();
      for (let i = 0; i < 5; i++) {
        await paginationMock.addAddressToTestSet(signers[i].address);
      }
    });

    it("should revert if pageNumber is 0", async function () {
      await expect(
        paginationMock.getAddressTestPage(0, 3)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should revert if pageSize is 0", async function () {
      await expect(
        paginationMock.getAddressTestPage(1, 0)
      ).to.be.revertedWithCustomError(paginationMock, "InvalidPaginationParameter");
    });

    it("should return correct page of addresses", async function () {
      const signers = await ethers.getSigners();
      const page = await paginationMock.getAddressTestPage(1, 2);
      expect(page).to.deep.equal([signers[0].address, signers[1].address]);
    });

    it("should return empty array if startIndex >= totalElements", async function () {
      const page = await paginationMock.getAddressTestPage(3, 5);
      expect(page.length).to.equal(0);
    });

    it("should adjust endIndex if it exceeds totalElements", async function () {
      const signers = await ethers.getSigners();
      const page = await paginationMock.getAddressTestPage(2, 3); 
      expect(page).to.deep.equal([signers[3].address, signers[4].address]);
    });
  });
});