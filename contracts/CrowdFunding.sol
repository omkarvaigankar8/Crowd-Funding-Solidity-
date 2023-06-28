// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
contract CrowdFunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping(uint256 => Campaign) public campaigns;
    // Mapping is done so that we can create a array for struct Campaign 
    uint256 public numberOfCampaigns =0;
// public means can be accessed by the frontend as well
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256) {
        Campaign storage campaign= campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp,"This deadline should be in future");
        campaign.owner=_owner;
        campaign.title=_title;
        campaign.description=_description;
        campaign.target=_target;
        campaign.deadline=_deadline;
        campaign.amountCollected=0;
        campaign.image=_image;

        numberOfCampaigns++;

        return numberOfCampaigns -1;
    }
    // payable means we will send crytocurrencies 
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign= campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        (bool sent,) = payable(campaign.owner).call{value:amount}("");
        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }
    function getDonators(uint256 _id) view public  returns(address [] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }
    function getCampaign()public view  returns(Campaign[] memory) {
            Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);        
            for(uint i=0; i< numberOfCampaigns; i++){
                Campaign storage item = campaigns[i];
                allCampaigns[i]=item;
            }
            return allCampaigns;
    }





}