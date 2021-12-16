const { ACCOUNT } = require('../../constants')

async function proxyBytecode (proxyOwnerAddress) {
  return '603e3d8160093d39f33d3d3d3d363d3d37363d71'
    + removeLeadingZeros(ACCOUNT.slice(2)).toLowerCase()
    + '5af43d3d93803e602857fd5bf3'
    + proxyOwnerAddress.slice(2).toLowerCase()
}

const removeLeadingZeros = s => s.replace(/^0+/, '')

module.exports = proxyBytecode
