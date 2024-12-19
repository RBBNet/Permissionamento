const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule('AdminMockModule', (m) => {
    const adminMockContract = m.contract('AdminMock', []);
    m.call(adminMockContract, "addAdmin", ['0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199']);
    return [ adminMockContract ];
});
