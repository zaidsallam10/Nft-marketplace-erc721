const { assert } = require("chai");
const KryptoBird = artifacts.require("./KryptoBird")


// check for chai
require("chai")
    .use(require("chai-as-promised"))
    .should()




contract("KryptoBird", (accounts) => {

    let contract=null
    // Will be called before all tests below
    before(async()=>{
        contract  = await KryptoBird.deployed();
    })


    // Checking for 1. contract 2. name 3. symbol
    describe("deployment", async () => {

        // Test1: Make sure that the contract is a. deplyed b. address not null
        it("deploys sucessfully", async () => {
            
            const address = contract.address;

            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })


        // Test2: Make sure that the name and symbol of the contract are = KryptoBird and KBZ
        it("checking for contract name and symbol", async () => {
            let name = await contract.name()
            let symbol = await contract.symbol()

            assert.notEqual(name, '');
            assert.notEqual(name, null);
            assert.notEqual(symbol, '');
            assert.notEqual(symbol, null);

            assert.equal(name, 'Kryptobird');
            assert.equal(symbol, 'KBZ');


        })
    })



    // Checking for 1. minting functions
    describe("Minting", async () => {

        it("creates a new token (to be minted)", async()=>{
            
            // Should work at the first time.
            let mintingResult= await contract.mint("https://1.png");
            const totalSupply= await contract.totalSupply();
           
            // make sure 1. total suply is =1, send and recevier addresses
            assert.equal(totalSupply,1);
            assert.equal(mintingResult.logs[0].args._from,'0x0000000000000000000000000000000000000000','from contract address');
            assert.equal(mintingResult.logs[0].args.to,accounts[0]._to,"to is msg.sender");

            // Should NOT work at the second time (because it has been minted already).
            await contract.mint("https://1.png").should.be.rejected;
        })

    })



})