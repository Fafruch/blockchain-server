// Importujemy kontrakt do testów za pomocą artifacts.require
const Lock = artifacts.require('./Lock.sol')

// 8/ Piszemy prosty test dla kontraktu
contract('Lock', (accounts) => {
  it('should return an owner', async () => {
    const instance = await Lock.deployed()
    const owner = await instance.owner.call()

    assert.equal(owner, accounts[0])
  })
})

contract('Lock', (accounts) => {
  it('should have no value after unlocking locked value', async () => {
    const instance = await Lock.deployed()

    await instance.lock({ sender: accounts[0], value: 5 })
    await instance.withdraw()
    await instance.unlock({ sender: accounts[0] })

    const valuePromise = await instance.locked.call(accounts[0])
    const valueAvailable = valuePromise[0]

    assert.equal(valueAvailable, 0)
  })
})
