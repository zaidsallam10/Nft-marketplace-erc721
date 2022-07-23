import React, { Component } from "react"
// For web3 functions
import Web3 from "web3"
// For connecting to metamask wallet
import detectEthereumProvider from "@metamask/detect-provider"
// to access our contract
import KryptoBird from "../abi/KryptoBird.json"
import {MDBCard,MDBCardBody,MDBCardTitle,MDBCardText, MDBCardImage,MDBBtn} from 'mdb-react-ui-kit'
import "./App.css"

export default class App extends Component {

    constructor(props) {
        super(props)
        this.state = {
            accounts: [],
            contract:null,
            totalSupply:0,
            KryptoBirdz:[],
            fileValue:""
        }
    }

    async componentDidMount() {
        await this.loadUserWallet()
        await this.loadBlockchainData()

    }


    // 1. Detecting the user wallet (metamask) 
    async loadUserWallet() {
        const provider = await detectEthereumProvider();

        // modern browser
        if (provider) {
            console.log("Etherum wallet is connected!!")
            // if there's  ether provider available
            window.web3 = new Web3(provider);
        } else {
            // alert("Ether wallet is not connected!")
            this.setState({
                accounts: "Ether wallet is not connected"
            })
        }
    }



    // 1. Getting my account
    // 2. accessing the network
    // 3. assigning my network to web3
    async loadBlockchainData() {
        const accounts = await window.web3.eth.getAccounts()
        console.log(accounts)
        if (accounts.length > 0) {

            this.setState({
                accounts: accounts
            })
            // Getting the current network id on metamase (make sure to switch to ganach account wallet)
            const networdId=await window.web3.eth.net.getId()
            // accessing the network id data
            const networkData= KryptoBird.networks[networdId]

            if(networkData){
                let abi=KryptoBird.abi
                let address= networkData.address 
                // assigning my newrok adress to web3 contract
                const contract =  new window.web3.eth.Contract(abi,address)
                console.log(contract)
                this.setState({contract})


            // Loading Total Supply
            let totalSupply=await contract.methods.totalSupply().call()
            this.setState({
                totalSupply
            })
            console.log("totalSupply=",totalSupply)


            // Loading Kryptobirds tokens
            let KryptoBirdz=[]
            for (let i=0;i<totalSupply;i++){
                let krypto=await contract.methods.KryptoBirdz(i).call() // it takes index
                KryptoBirdz.push(krypto)
               
            }
            this.setState({
                KryptoBirdz
            })
            console.log("Minted KryptoBirdz====",KryptoBirdz)
            }else{
                alert("Smart contract not deployed yet!!")
            }

        }
        else {
            this.setState({
                accounts: "Please choose your Eth account!"
            })
        }
    }


    // to mint new tokens
    mint= (kryptoBird) =>{
        if(this.state.accounts.length>0){
            this.state.contract.methods.mint(kryptoBird).send({from:this.state.accounts[0]})
            .once('reseipt',(reseipt)=>{
                this.setState({
                    KryptoBirdz:[...this.state.KryptoBirdz,kryptoBird]
                })
            })
        }
      
    }


    render() {
        return (
            <div className="container-filled">
                {console.log(this.state.KryptoBirdz)}
                <nav className="navbar navbar-dark fixed-top bg-dark  flex-md-nowrap p-0 shadow">
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{ color: 'white' }}>
                        KryptoZaid (NFT)
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">
                                {this.state.accounts}
                            </small>
                        </li>

                    </ul>
                </nav>


            <div className="container-fluid mt-1">
                <div className="row">
                    <main role="main" className="col-lg-12 d-flex text-center">
                        <div className="content mr-auto ml-auto"
                        style={{opacity:'0.8'}}
                        >  
                        <h1 style={{color:'black'}}>KryptoBirdZ - NFT Marketplace</h1>
                        <br/>
                        <form onSubmit={(event)=>{
                            event.preventDefault()
                            this.mint(this.state.fileValue)
                        }}>

                        <input type="text" placeholder="Add a your NFT file location"
                        className="form-control mb-1"
                        onChange={((e)=>{
                            this.setState({
                                fileValue:e.target.value
                            })
                        })}
                        // ref={(input)=>this.kryptoBird=input}
                        />

                        <input
                        style={{margin:'6px'}}
                        type="submit"
                        value="Mint"
                        className="btn btn-primary btn-black"
                        />


                        </form>

                        </div>
                    </main>
                </div>
                <hr></hr>

<div className="row textCenter">
{
    this.state.KryptoBirdz.map((item, key)=>{
        return(
            <div>
                <div>
                    <MDBCard className="token img" style={{maxWidth:'22rem'}}>
                        <MDBCardImage height='250rem' src={item} position="top" style={{marginRight:'4px'}}></MDBCardImage>
                        <MDBCardBody>
                            <MDBCardTitle>
                                KryptoBirdZ
                            </MDBCardTitle>
                            <MDBCardText>The KryptoBirdz are 20 uniqely generated KBirdz from the galaxy mestopia!There's only one of each bird and each bird can be owned by one person on
                                Ethereum Blockchain!
                            </MDBCardText>
                            <MDBBtn href={item}>Download</MDBBtn>
                        </MDBCardBody>
                    </MDBCard>
                    </div>
                </div>
        )
    })
}
</div>

            </div>
            </div>
        )
    }

}