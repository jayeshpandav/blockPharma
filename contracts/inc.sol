// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    address public Owner;

    //Medicine count
    uint256 public medicineCount = 0;
    //Raw material supplier count
    uint256 public rmsCount = 0;
    //Manufacturer count
    uint256 public manCount = 0;
    //distributor count
    uint256 public disCount = 0;
    //retailer count
    uint256 public retCount = 0;

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    constructor(){
        Owner = msg.sender;
    }

    modifier onlyByOwner() {
        require(msg.sender == Owner);
        _;
    }

    //stages of a medicine in pharma supply chain
    enum STAGE {
        Init,
        RawMaterialSupply,
        Manufacture,
        Distribution,
        Retail,
        sold
    }
    //using this we are going to track every single medicine the owner orders


    //To store information about the medicine
    struct medicine {
        uint256 id; //unique medicine id
        string name; //name of the medicine
        string description; //about medicine
        uint256 RMSid; //id of the Raw Material supplier for this particular medicine
        uint256 MANid; //id of the Manufacturer for this particular medicine
        uint256 DISid; //id of the distributor for this particular medicine
        uint256 RETid; //id of the retailer for this particular medicine
        STAGE stage; //current medicine stage
    }


    mapping(uint256 => medicine) public MedicineStock;

   
   function showStage(uint256 _medicineID) public view returns (string memory stage) {
    require(medicineCount > 0);
    
    if (MedicineStock[_medicineID].stage == STAGE.Init)
        stage = "Medicine Ordered";
    else if (MedicineStock[_medicineID].stage == STAGE.RawMaterialSupply)
        stage = "Raw Material Supply Stage";
    else if (MedicineStock[_medicineID].stage == STAGE.Manufacture)
        stage = "Manufacturing Stage";
    else if (MedicineStock[_medicineID].stage == STAGE.Distribution)
        stage = "Distribution Stage";
    else if (MedicineStock[_medicineID].stage == STAGE.Retail)
        stage = "Retail Stage";
    else if (MedicineStock[_medicineID].stage == STAGE.sold)
        stage = "Medicine Sold";

    return stage;
}
//The function first checks if medicineCtr is greater than zero by calling the require function. This is a way to check a condition and revert the transaction if it is not met.


//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   
    struct info_rawMaterialSupplier {
        address address_of_rawMaterialSupplier;
        uint256 id_of_rawMaterialSupplier;
        string name_of_rawMaterialSupplier;
        string place_of_rawMaterialSupplier; 
    }

    
    struct info_manufacturer {
        address address_of_manufacturer;
        uint256 id_of_manufacturer;
        string name_of_manufacturer; 
        string place_of_manufacturer; 
    }

    
    struct info_distributor {
        address address_of_distributor;
        uint256 id_of_distributor;
        string name_of_distributor; 
        string place_of_distributor; 
    }


    struct info_retailer {
        address address_of_retailer;
        uint256 id_of_retailer; 
        string name_of_retailer; 
        string place_of_retailer; 
    }


//-------------------------------------------------------------------------------------------------------------------------------------------------
    //To store all the raw material suppliers on the blockchain
    mapping(uint256 => info_rawMaterialSupplier) public RMS;

    //To store all the manufacturers on the blockchain
    mapping(uint256 => info_manufacturer) public MAN;

      //To store all the distributors on the blockchain
    mapping(uint256 => info_distributor) public DIS;

    //To store all the retailers on the blockchain
    mapping(uint256 => info_retailer) public RET;
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    function add_RMS_in_blockchain(address _address,string memory _name, string memory _place) public onlyByOwner() {
        rmsCount++;
        RMS[rmsCount] = info_rawMaterialSupplier(_address, rmsCount, _name, _place);
    }


    function add_Manufacturer_in_blockchain(address _address,string memory _name,string memory _place) public onlyByOwner() {
        manCount++;
        MAN[manCount] = info_manufacturer(_address, manCount, _name, _place);
    }

  
    function add_Distributor_in_blockchain(address _address,string memory _name,string memory _place) public onlyByOwner() {
        disCount++;
        DIS[disCount] = info_distributor(_address, disCount, _name, _place);
    }

    function add_Retailer_in_blockchain(address _address,string memory _name,string memory _place) public onlyByOwner() {
        retCount++;
        RET[retCount] = info_retailer(_address, retCount, _name, _place);
    }

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //To supply raw materials from RMS supplier to the manufacturer
    function RMS_to_manufacture_supply(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCount);
        uint256 _id = check_RMS_is_available(msg.sender);
        require(_id > 0);
        require(MedicineStock[_medicineID].stage == STAGE.Init);
        MedicineStock[_medicineID].RMSid = _id;
        MedicineStock[_medicineID].stage = STAGE.RawMaterialSupply;
    }

    
    function check_RMS_is_available(address _address) private view returns (uint256) {
        require(rmsCount > 0);
        for (uint256 i = 1; i <= rmsCount; i++) {
            if (RMS[i].address_of_rawMaterialSupplier == _address) return RMS[i].id_of_rawMaterialSupplier;
        }
        return 0;
    }

    //To manufacture medicine
    function Manufacturing(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCount);
        uint256 _id = check_MAN_is_available(msg.sender);
        require(_id > 0);
        require(MedicineStock[_medicineID].stage == STAGE.RawMaterialSupply);
        MedicineStock[_medicineID].MANid = _id;
        MedicineStock[_medicineID].stage = STAGE.Manufacture;
    }

    function check_MAN_is_available(address _address) private view returns (uint256) {
        require(manCount > 0);
        for (uint256 i = 1; i <= manCount; i++) {
            if (MAN[i].address_of_manufacturer == _address) return MAN[i].id_of_manufacturer;
        }
        return 0;
    }

    //To supply medicines from Manufacturer to distributor
    function manufacture_to_Distribute(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCount);
        uint256 _id = check_distributor_is_available(msg.sender);
        require(_id > 0);
        require(MedicineStock[_medicineID].stage == STAGE.Manufacture);
        MedicineStock[_medicineID].DISid = _id;
        MedicineStock[_medicineID].stage = STAGE.Distribution;
    }

    
    function check_distributor_is_available(address _address) private view returns (uint256) {
        require(disCount > 0);
        for (uint256 i = 1; i <= disCount; i++) {
            if (DIS[i].address_of_distributor == _address) return DIS[i].id_of_distributor;
        }
        return 0;
    }

    //To supply medicines from distributor to retailer
    function distributor_to_Retail(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCount);
        uint256 _id = check_retailer_is_available(msg.sender);
        require(_id > 0);
        require(MedicineStock[_medicineID].stage == STAGE.Distribution);
        MedicineStock[_medicineID].RETid = _id;
        MedicineStock[_medicineID].stage = STAGE.Retail;
    }

   
    function check_retailer_is_available(address _address) private view returns (uint256) {
        require(retCount > 0);
        for (uint256 i = 1; i <= retCount; i++) {
            if (RET[i].address_of_retailer == _address) return RET[i].id_of_retailer;
        }
        return 0;
    }

    //To sell medicines from retailer to consumer
    function sold(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCount);
        uint256 _id = check_retailer_is_available(msg.sender);
        require(_id > 0);
        require(_id == MedicineStock[_medicineID].RETid);
        require(MedicineStock[_medicineID].stage == STAGE.Retail);
        MedicineStock[_medicineID].stage = STAGE.sold;
    }


    function addMedicine(string memory _name, string memory _description) public onlyByOwner()
    {
        require((rmsCount > 0) && (manCount > 0) && (disCount > 0) && (retCount > 0));
        medicineCount++;
        MedicineStock[medicineCount] = medicine(
            medicineCount,
            _name,
            _description,
            0,
            0,
            0,
            0,
            STAGE.Init
        );
    }
}