

import UIKit

enum Valid{
    case success
    case failure(Alert,String)
}

class Validation: NSObject {
    
    static let shared = Validation()
    var errorMessage = ""
    
    func errorMsg(str : String) -> Valid{
        return .failure(.error,str)
    }
    
    func isValidLogin(email: String? , password: String? ) -> Valid{
        if isValid(type: .userNameOrEmail, info: email) &&  isValid(type: .emailPassword, info: password){
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    private func isValid(type : FieldType , info: String?) -> Bool {
        guard let validStatus = info?.handleStatus(fieldType : type) else {
            return true
        }
        errorMessage = validStatus
        return false
    }
    
    private func isValid(image: UIImage?) -> Bool {
        if image != nil{
            return true
        }
        errorMessage = "Please upload image"
        return false
    }
    
    private func isValid(image: [UIImage?]?, videoData : [URL?]?, metaTagImage :String?) -> Bool {
        
        if ((image?.count == 0) && (videoData?.count == 0)) && (metaTagImage == "") {
            errorMessage = "Please choose photo or video"
            return false
        }
        return true
    }
    
    private func isValid(array : [Any]?) -> Bool {
        
        if (array == nil) || (/array?.isEmpty) {
            errorMessage = "Please choose tags."
            return false
        }
        return true
    }
    
    private func isValidEditPost(array : [Any]?) -> Bool {
        
        if (array == nil) || (/array?.isEmpty) {
            errorMessage = "Please choose photo or video."
            return false
        }
        return true
    }
    
    func isValidSignUpData( name: String? , email: String? , phoneNumber: String? , password: String? , location: String?, education: String?,  industry: String?, company: String?,experience: String?, isSelectedTermsAndPolicy: Bool?) -> Valid{
        
        if isValid(type: .name, info: name)  &&   isValid(type: .email, info: email) && isValid(type: .phoneNumber, info: phoneNumber) && isValid(type:.password ,  info: password) && isValid(type:.location ,  info: location) && isValid(type:.education ,  info: education)  && isValid(type:.industry ,  info: industry)  && isValid(type:.company ,  info: company) && isValid(type:.experience ,  info: experience) && isAgreedToTermsAndPolicy(value: isSelectedTermsAndPolicy)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidUpdateProfileData( name: String?  , location: String?, education: String?,  industry: String?, company: String?,experience: String?) -> Valid{
        
        if isValid(type: .name, info: name)  && isValid(type:.location ,  info: location) && isValid(type:.education ,  info: education)  && isValid(type:.industry ,  info: industry)  && isValid(type:.company ,  info: company) && isValid(type:.experience ,  info: experience)   {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidLoginData( email: String? , password: String? ) -> Valid{
        
        if isValid(type: .email, info: email) && isValid(type:.emailPassword ,  info: password)   {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidVerificationData( OTP: String?) -> Valid{
        
        if isValid(type:.verificationCode ,  info: OTP)   {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    
    func isValidCreateFeedData(image: [UIImage?]?, video:[URL?]?,metaTagImage:String?, title: String?, tags: [Any]?,  description: String?) -> Valid{
        
        if isValid(image: image, videoData: video, metaTagImage : metaTagImage) && isValid(type: .title,  info: title) && isValid(array: tags) && isValid(type: .description, info: description)    {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidUpdateFeedData( collectionFiles: [Any]?, title: String?, tags: [Any]?,  description: String?) -> Valid{
        
        if  isValidEditPost(array: collectionFiles) && isValid(type: .title,  info: title) && isValid(array: tags) && isValid(type: .description, info: description)    {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    //***********************************************************************************************************************
    
   /* func isValid(name full:String? , password: String? , email: String?) -> Valid{
        if isValid(type: .email, info: email) && isValid(type: .firstName, info: full) && isValid(type: .password, info: password)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    
    func isValidEditProfile(name first:String? , last:String? , image: UIImage?  , userName: String? , email: String?) -> Valid{
        if isValid(image: image) && isValid(type: .firstName, info: first) &&  isValid(type: .lastName, info: last) && isValid(type: .userName , info: userName) && isValid(type: .email, info: email)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidFb(name first:String? , last:String? , image: UIImage?  , userName: String?, email: String? ) -> Valid{
        if isValid(type: .firstName, info: first) &&  isValid(type: .lastName, info: last) && isValid(type: .userName , info: userName) && isValid(type: .email, info: email) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidSocialLoginInfo(first:String? , last:String? ) -> Valid{
        if isValid(type: .firstName, info: first) &&  isValid(type: .lastName, info: last){
            return .success
        }
        return errorMsg(str: errorMessage)
    } */
    
    func isValidAlreadyExist(phoneNum: String? , countryCode: String?) -> Valid {
        if isValid(type: .mobile, info: phoneNum)  && isValid(type: .countryCode, info: countryCode){
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidOTP(otpText:String?) -> Valid {
        if isValid(type: .otp, info: otpText) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidForgetPassword(email: String? ) -> Valid{
        if isValid(type: .email, info: email){
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValid(phoneNum: String? ) -> Valid{
        if isValid(type: .mobile, info: phoneNum){
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidaComment(comment: String? ) -> Valid{
        if isValid(type: .comment, info: comment){
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
   /* func isValidProfile(name: String? , phone: String? ) -> Valid{
        if isValid(type: .firstName , info: name) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidSignUp( firstName: String? ,  password: String?  , email: String? , phone: String? ) -> Valid{
        if isValid(type: .firstName, info: firstName)  &&   isValid(type: .email, info: email) && isValid(type: .mobile, info: phone) && isValid(type: .password, info: password)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidLeadData( firstName: String?   , email: String? , phone: String? ) -> Valid{
        if isValid(type: .firstName, info: firstName)  &&   isValid(type: .email, info: email) && isValid(type: .mobile, info: phone)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    } */
    
    func isValidLogin( password: String? , email: String? ) -> Valid{
        if isValid(type: .email, info: email) && isValid(type: .password, info: password) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidReForget( password: String? , userName: String? ) -> Valid{
        if isValid(type: .confirmationCode, info: userName) && isValid(type: .password, info: password) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    
    func isValidProfileData( name: String?   , dob: String? , gender: String? , maritalStatus: String? , countryCode: String?, mobileNumber: String?,  country: String?, state: String?,city: String?, zipCode: String?, passCode: String?) -> Valid{
        
        if isValid(type: .fullName, info: name)  &&   isValid(type: .dob, info: dob) && isValid(type: .gender, info: gender) && isValid(type:.maritalStatus ,  info: maritalStatus) && isValid(type:.countryCode ,  info: countryCode) && isValid(type:.mobile ,  info: mobileNumber)  && isValid(type:.country ,  info: country)  && isValid(type:.state ,  info: state) && isValid(type:.city ,  info: city) && isValid(type:.postalCode ,  info: zipCode) && isValid(type:.passCode ,  info: passCode)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidDesignateData( fullname: String?   , phoneNumber: String? , email: String?, relation: String? ) -> Valid{
        
        if isValid(type: .fullName, info: fullname)  && isValid(type:.mobile ,  info: phoneNumber) &&   isValid(type:.email ,  info: email)  && isValid(type: .relation, info: relation)  {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidChangePassCodeData(oldPasscode : String?, newPasscode : String?, confirmNewPasscode: String?) -> Valid {
        
        if isValid(type: .oldPasscode, info: oldPasscode)  && isValid(type: .newPasscode, info: newPasscode) && isValid(type: .confirmNewPasscode, info: confirmNewPasscode) && (isValueMatched(type: .confirmNewPasscode, value: newPasscode, confirmValue: confirmNewPasscode)) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidChangePassword(oldPassword: String?  , newPassword: String?, confirmNewPassword: String? ) -> Valid{
        
        if isValid(type: .oldPassword, info: oldPassword) && isValid(type: .newPassword, info: newPassword) && isValid(type: .confirmNewPassword, info: confirmNewPassword) && (isValueMatched(type: .confirmNewPassword, value: newPassword, confirmValue: confirmNewPassword)) {
            return .success
        }
        return errorMsg(str: errorMessage)
    }
    
    private func isValueMatched(type : FieldType ,value: String?, confirmValue : String?) -> Bool {
        if value == confirmValue{
            return true
        }
        
        if type == .confirmNewPasscode {
            errorMessage = "New password and confirm password does not match."
        } else {
            errorMessage = "New password and confirm password does not match."
        }
        
        return false
    }
    
    private func isAgreedToTermsAndPolicy(value: Bool?) -> Bool {
        
        if !(/value) {
            errorMessage = "Please agree to terms & conditions."
            return false
        }
        
        return true
    }
    
    
    private func isPeopleAdded(designates : Int?, others: Int?) -> Bool {
        
        if /designates > 0 || /others > 0 {
            return true
        }
        
        errorMessage = "Please enter at least a designate or a professional."
        return false
    }
    
    func isValidAddDescription(description : String?) -> Valid {
        
        if isValid(type: .description, info: description) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddRealEstate(propetyName : String?, propetyDescription : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .propertyName, info: propetyName) &&  isValid(type: .propertyDescription, info: propetyDescription) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddRealEstateWithOther(propetyName : String?, propetyDescriptionOther : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .propertyName, info: propetyName) &&  isValid(type: .propertyDescriptionOther, info: propetyDescriptionOther) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddShoeBox(name : String?, description : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .itemName, info: name) &&  isValid(type: .itemDescription, info: description) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddShoeBoxWithOther(name : String?, description : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .itemName, info: name) &&  isValid(type: .itemDescriptionOther, info: description) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddInvestment(name : String?, description : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .investmentName, info: name) &&  isValid(type: .investmentDescription, info: description) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddInvestmentWithOther(name : String?, description : String?, designates : Int?, others: Int?) -> Valid {
        
        if isValid(type: .investmentName, info: name) &&  isValid(type: .investmentDescriptionOther, info: description) && isPeopleAdded(designates: designates, others: others) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidAddBank(country : String?, state : String?, bank : String?) -> Valid {
        
        if isValid(type: .bankCountry, info: country) &&  isValid(type: .bankState, info: state) &&  isValid(type: .bank, info: bank) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
    func isValidVerifyPasscode(passcode : String?) -> Valid {
        
        if isValid(type:.passCode ,  info: passcode) {
            return.success
        }
        return errorMsg(str: errorMessage)
    }
    
   /* func isValidAddCardInfo(cardNumber : String?, expiry : String?, cvv: String?, firstName : String?)  -> Valid {
        
        if isValid(type: .cardNumber
            , info: cardNumber) &&  isValid(type: .expiry, info: expiry) &&  isValid(type: .cvv, info: cvv) &&  isValid(type: .firstName, info: firstName) {
            return .success
        }
        return errorMsg(str: errorMessage)
    } */
}


import UIKit

enum FieldType : String {
    
    //***************NS
    case name
    case email
    case phoneNumber = "phone number"
    case password
    case location
    case education
    case industry
    case company
    case experience
    case emailPassword    = "password "
    case verificationCode    = "Verification Code"
    case title = "post title"
    
    //******************
    
    case confirmationCode = "confirmation code"
   // case firstName        = "name"
    case fullName         = "full name"
    case lastName         = "last name"
  //  case email            = "Email Address"
  //  case password         = "Password"
   
    case oldPassword      = "Old Password"
    case confirmNewPassword = "Re-enter New Password"
    case newPassword      = "New Password"
    case info             = ""
    case mobile           = "Phone Number"
    case cardNumber       = "Card Number"
    case cvv              = "CVV"
    case expiry           = "Expiry"
    case zip              = "Zip Code"
    case amount           = "Amount"
    case image
    case userName         = "Username"
    case userNameOrEmail  = "Email id"
    case comment          = "Comment"
    case nationalId       = "National ID Number"
    case address          = "Address"
    case areas            = "Road Number"
    case postalCode       = "Postal Code"
    case city             = "City"
    case state, bankState = "State"
    case country, bankCountry = "Country"
    case countryCode      = "Country code"
    case buildingName     = "Block Number"
    case apartment        = "Apartment / Villa No"
    case otp              = "OTP"
    case vehicleMake      = "vehicle make"
    case model            = "model"
    case color            = "color"
    case version          = "version"
    case year             = "year"
    case licencePlate     = "licence plate"
    case gas              = "Gas grade"
    case frontView        = "Front view Image"
    case backView         = "Back View Image"
    case sideView         = "Side View Image"
    case dob              = "Date of Birth"
    case gender           = "Gender"
    case maritalStatus    = "Marital Status"
    case passCode         = "Passcode"
    case oldPasscode      = "Old Passcode"
    case newPasscode      = "New Passcode"
    case confirmNewPasscode = "Re-enter New Passcode"
    case relation         = "Relation"
    case description      = "description"
    case propertyName     = "Property Name"
    case propertyDescription, propertyDescriptionOther = "Property Description"
    case itemName            = "Item Name"
    case investmentName      = "Investment Name"
    case investmentDescription, investmentDescriptionOther = "Investment Description"
    case itemDescription, itemDescriptionOther = "Item Description"
    case bank            = "Bank"
}

extension String {
    
    enum Status : String {
        
        case chooseEmpty        = "Please choose "
        case selectEmpty        = "Please select "
        case empty              = "Please enter "
        case emptyDescription   = "Please add "
        case emptyPostDescription = "Please describe the post."
        case allSpaces          = "field should not be blank "
        case singleDot          = "Only single period allowed for "
        case singleDash         = "Only single dash allowed for "
        case singleSpace        = "Only single space allowed for "
        case singleApostrophes  = "Only single apostrophes allowed for "
        case valid
        case inValid            = "Please enter valid "
        case allZeros           = " Please enter valid "
        
        case hasSpecialCharacter = " must not contain special character."
        case hasAlphabets        = " must contain numeric digits only."
        case notANumber          = " must be a number"
        case passwrdLength       = " has to be at least 6 characters."
        case mobileNumberLength  = "Phone number must be 5-15 digits."
        case passcodeNumberLength = "Passcode length Must be 4 to 6 digits."
        
        case postalcodeNumberLength = " length Must be 3 to 10 digits."
        case emptyCountrCode        = " Choose country code."
        case containsSpace          = " field should not contain space."
        
        case containsAtTheRateCharacter = " field should not contain @ character"
        case minimumCharacters          = " field should have atleast two characters"
        case minimumUsernameCharacters  = " field should have atleast six characters"
        case passwordFormat             = " "
        case usernameFormat             = " field should have alphabetic characters, numeric characters, underscores, periods, and dashes only"
        case passwordValidation         = " must be at least 6 characters long and must contain 1 upper case, 1 lower case character, 1 numeric and 1 special character."
        case passwordValidationOldChange         = "Invalid "

        case emptyMaritalStatus         = "Please select a relationship status"
        case emptyGender                = "Please select your gender"
        case emptyRelation              = "Sorry! Must select relationship."
        
        
        func message(type : FieldType) -> String? {
            
            switch self {
            case .passwrdLength, .passwordValidation :
                return type.rawValue.lowercased() + rawValue
            case .hasSpecialCharacter , .hasAlphabets, .allSpaces , .passwordFormat ,.usernameFormat, .postalcodeNumberLength :
                return type.rawValue.lowercased() + rawValue
                
            case .valid:
                return nil
                
            case .mobileNumberLength , .emptyCountrCode , .passcodeNumberLength, .emptyGender, .emptyMaritalStatus, .emptyPostDescription :
                return  rawValue
                
            case .containsSpace:
                return type.rawValue.lowercased() + rawValue
                
            case .containsAtTheRateCharacter ,  .minimumCharacters , .minimumUsernameCharacters :
                return type.rawValue.lowercased() + rawValue
                
            default:
                return rawValue + type.rawValue.lowercased()
            }
        }
    }
    
    func handleStatus(fieldType : FieldType) -> String? {
        
        switch fieldType {
            
        case .confirmationCode:
            return isValidInformation.message(type: fieldType)
        case .name , .lastName, .fullName, .education, .industry, .company , .experience :
            return  isValidName.message(type: fieldType)
        case .userName:
            return  isValidUserName.message(type: fieldType)
        case .email:
            return  isValidEmail.message(type: fieldType)
        case .password  , .newPassword, .confirmNewPassword:
            return  isValid(password: 6, max: 20).message(type: fieldType)
            
        case  .oldPassword:
            return isValidOldOnChange(password: 6, max: 20).message(type: fieldType)
            
        case .info:
            return  isValidInformation.message(type: fieldType)
        case .mobile, .phoneNumber:
            return  isValidPhoneNumber.message(type: fieldType)
        case .relation:
            return isValidRelation.message(type: fieldType)
        case .cardNumber:
            return  isValidCardNumber(length: 19).message(type: fieldType)
        case .cvv:
            return  isValidCVV.message(type: fieldType)
        case .expiry :
            return isValidExpiry.message(type: fieldType)
        case .zip:
            return  isValidZipCode.message(type: fieldType)
        case .amount:
            return  isValidAmount.message(type: fieldType)
        case .image:
            return "Please upload image"
        case .userNameOrEmail:
            return isValidLogin.message(type:fieldType)
        case .emailPassword, .verificationCode:
            return isValidLoginPassword.message(type:fieldType)
        case .comment:
            return isValidComment.message(type:fieldType)
        case .nationalId:
            return  isValidInformation.message(type: fieldType)
        case .address , .location:
             return isValidLocation.message(type: fieldType)
        case .title :
            return  isValidInformation.message(type: fieldType)
        case .description:
            return isValidDescription.message(type:fieldType)
        case .postalCode:
            return  isValidPostalCode.message(type: fieldType)
        case .city:
            return  isValidInformation.message(type: fieldType)
        case .state:
            return  isValidInformation.message(type: fieldType)
        case .country:
            return  isValidInformation.message(type: fieldType)
        case .countryCode:
            return  isValidCountryCode.message(type:fieldType)
        case .buildingName:
            return isValidInformation.message(type: fieldType)
        case .apartment:
            return isValidInformation.message(type: fieldType)
        case .areas:
            return isValidInformation.message(type: fieldType)
        case .otp:
            return isValidInformationOTP.message(type: fieldType)
        case .vehicleMake :
            return isValidVehicleInformation.message(type: fieldType)
        case .model :
            return isValidVehicleInformation.message(type: fieldType)
        case .color :
            return isValidVehicleInformation.message(type: fieldType)
        case .version :
            return isValidVehicleInformation.message(type: fieldType)
        case .year :
            return isValidVehicleInformation.message(type: fieldType)
        case .licencePlate :
            return isValidInformation.message(type: fieldType)
        case .gas :
            return isValidVehicleInformation.message(type: fieldType)
        case .frontView :
            return isValidInformation.message(type: fieldType)
        case .backView :
            return isValidInformation.message(type: fieldType)
        case .sideView :
            return isValidInformation.message(type: fieldType)
        case .dob :
            return isValidDob.message(type: fieldType)
        case .gender :
            return isValidGender.message(type: fieldType)
        case .maritalStatus :
            return isValidMaritalStatus.message(type: fieldType)
        case .passCode, .oldPasscode, .newPasscode, .confirmNewPasscode :
            return isValidPassCode.message(type: fieldType)
        case .propertyName, .itemName, .investmentName, .propertyDescriptionOther, .itemDescriptionOther, .investmentDescriptionOther:
            return isValidPropertyInfo.message(type: fieldType)
        case .propertyDescription:
            return isValidRealEstateDescription.message(type: fieldType)
        case .itemDescription:
            return isValidShoeBoxDescription.message(type: fieldType)
        case .investmentDescription:
            return isValidInvestmentDescription.message(type: fieldType)
        case .bankCountry, .bankState, .bank:
            return isValidBankInfo.message(type: fieldType)
        }
    }
    
    var isNumber : Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    var hasSpecialCharcters : Bool {
        return rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil
    }
    
    var hasAlphabets : Bool {
        return rangeOfCharacter(from: CharacterSet.letters) != nil
    }
    
    var isEveryCharcterZero : Bool{
        var count = 0
        self.forEach {
            if $0 == "0"{
                count += 1
            }
        }
        if count == self.count{
            return true
        }else{
            return false
        }
    }
    
    public func toString(format: String , date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public var length: Int {
        return self.count
    }
    
    public var isEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public var notOnlyString : Bool {
        
        let set = CharacterSet(charactersIn: "*=+[]\\|;:'\",<>{}()/?%")
        let inverted = set.inverted
        let filtered = self.components(separatedBy: inverted).joined(separator: "")
        return !filtered.isEmpty
    }
    
    
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    public var isSingleDotOrNoDot : Bool{
        get {
            let count = self.countInstances(of: ".")
            return (count == 0 || count == 1)
        }
    }
    
    public var isSingleSpaceOrNoSpace : Bool{
        get {
            let count = self.countInstances(of: " ")
            return (count == 0 || count == 1)
        }
    }
    
    public var isFirstCharacterAlphabet : Bool {
        get {
            guard let char = self.utf16.first else{return true}
            return (CharacterSet.letters as NSCharacterSet).characterIsMember(char)
        }
    }
    
    
    public var isSingleDashOrNoDash : Bool{
        get {
            let count = self.countInstances(of: "-")
            return (count == 0 || count == 1)
        }
    }
    
    
    public var isSingleApostrophesOrNoApostrophes: Bool{
        get {
            let count = self.countInstances(of: "'")
            return (count == 0 || count == 1)
        }
    }
    
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var searchRange: Range<String.Index>?
        var count = 0
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            count += 1
        }
        return count
    }
    
    var isValidUserName : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        //        if self.contains(" ") { return .containsSpace }
        if !(length >= 6) { return .minimumUsernameCharacters }
        if hasSpecialCharcters {
            let isUsernameFormat = checkUsername(text: self)
            if !isUsernameFormat { return .usernameFormat }
        }
        if notOnlyString {return .hasSpecialCharacter}
        //        if self.contains("@") { return .containsAtTheRateCharacter }
        return .valid
    }
    
    func isValid(password min: Int , max: Int) -> Status {
        if length <= 0 { return .empty }
        if isBlank  { return .empty  }
        if self.contains(" ") { return .containsSpace }
        //let isPasswordFormat = checkPassword(text: self)
        // if !isPasswordFormat { return .passwordFormat }
        /* if !(self.count >= min && self.count <= max) {
         return .passwrdLength
         } */
        if !checkPassword(text: self){ return .passwordValidation }
        
        return .valid
    }
    
    func isValidOldOnChange(password min: Int , max: Int) -> Status {
        if length <= 0 { return .empty }
        if isBlank  { return .empty  }
        if self.contains(" ") { return .containsSpace }
        //let isPasswordFormat = checkPassword(text: self)
        // if !isPasswordFormat { return .passwordFormat }
        /* if !(self.count >= min && self.count <= max) {
         return .passwrdLength
         } */
        if !checkPassword(text: self){ return .passwordValidationOldChange }
        
        return .valid
    }
    
    var isValidLoginPassword: Status {
        if length <= 0 { return .empty }
        if isBlank  { return .allSpaces  }
        return .valid
    }
    
    func checkPassword(text : String?) -> Bool{
        
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isMatched = passwordValidation.evaluate(with: text)
        if isMatched{
            return true
        }else {
            return false
        }
    }
    
    func checkUsername(text : String?) -> Bool{
        let characterSet:  NSMutableCharacterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "_-.")
        let characterSetInverted:  NSMutableCharacterSet = characterSet.inverted as! NSMutableCharacterSet
        if text?.rangeOfCharacter(from: characterSetInverted as CharacterSet) != nil {
            return false
        }else {
            return true
        }
    }
    
    func getCurrentYear () -> Int? {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        // let month = calendar.component(.month, from: date)
        
        return (year)
    }
    
    var isValidComment : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }
    
    var isValidEmail : Status {
        if length <= 0 { return .empty }
        if isBlank { return .empty }
        if !isFirstCharacterAlphabet{ return .inValid }
        if !isEmail { return .inValid }
        return .valid
    }
    
    var isValidLogin : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }
    
    var isValidInformationOTP : Status {
        if isBlank { return .empty }
        if length != 4{ return .inValid }
        return .valid
    }
    
    var isValidInformation : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        if isEveryCharcterZero { return .allZeros}
       // if notOnlyString {return .hasSpecialCharacter}
        return .valid
    }
    
    var isValidVehicleInformation : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }
    
    var isValidCountryCode : Status {
        if self  == "" || self == "+" { return .chooseEmpty }
        return .valid
    }
    
    var isValidLocation : Status {
        if self  == "" { return .chooseEmpty }
        return .valid
    }
    
    var isValidDob : Status {
        if self  == "Date of Birth" { return .chooseEmpty }
        return .valid
    }
    
    var isValidGender : Status {
        if self  == "Gender" { return .emptyGender }
        return .valid
    }
    
    var isValidMaritalStatus : Status {
        if self  == "Marital Status" { return .emptyMaritalStatus }
        return .valid
    }
    
    var isValidPhoneNumber : Status {
        
        let text = self.removeSpecialCharacter()
        if text.length < 0 { return .empty }
        if text.isBlank { return .empty }
        if text.isEveryCharcterZero { return .allZeros }
        /*  if hasSpecialCharcters {
         return text..hasSpecialCharacter
         } */
        if text.hasAlphabets {
            return .hasAlphabets
        }
        if text.count >= 5 && text.count <= 15 { return .valid
        }else{
            return .mobileNumberLength
        }
    }
    
    var isValidPassCode : Status {
        if length < 0 { return .empty }
        if isBlank { return .empty }
        if isEveryCharcterZero { return .allZeros }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if notOnlyString {return .hasSpecialCharacter}
        if isNumber {
            if count >= 4 && self.count <= 6 { return .valid
            }else{
                return .passcodeNumberLength
            }
        } else {
            return .notANumber
        }
    }
    
    var isValidPostalCode : Status {
        if length < 0 { return .empty }
        if isBlank { return .empty }
        if isEveryCharcterZero { return .allZeros }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if notOnlyString {return .hasSpecialCharacter}
        if count >= 3 && self.count <= 10 {
            return .valid
        }else{
            return .postalcodeNumberLength
        }
    }
    
    
    var isValidRelation : Status {
        if self == "Select Relation" { return .emptyRelation }
        return .valid
    }
    
    var isValidInvestmentDescription : Status {
        if self == "Investment Description" { return .chooseEmpty }
        return .valid
    }
    
    var isValidShoeBoxDescription : Status {
        if self == "Item Description" { return .chooseEmpty }
        return .valid
    }
    
    var isValidRealEstateDescription : Status {
        if self == "Property Description" { return .chooseEmpty }
        return .valid
    }
    
    var isValidBankInfo : Status {
        if self == "Country" { return .selectEmpty }
        if self == "State" { return .selectEmpty }
        if self == "Bank" { return .selectEmpty }
        return .valid
    }
    
    var isValidName : Status {
        if length < 0 { return .empty }
        if isBlank { return .empty }
        if notOnlyString {return .hasSpecialCharacter}
        
        return .valid
    }
    
    func isValidCardNumber(length max:Int ) -> Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if characters.count >= 12 && characters.count <= max{
            return .valid
        }
        return .inValid
    }
    
    var isValidCVV : Status {
        if length == 0 { return .empty }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if isNumber{
            if self.characters.count >= 3 && self.characters.count <= 4{
                return .valid
            }else{ return .inValid }
        }else { return .notANumber }
    }
    
    var isValidExpiryYear : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if isNumber{
            if self.characters.count == 2 {
                return .valid
            }else{ return .inValid }
        }else { return .notANumber }
    }
    
    var isValidExpiry : Status {
        if length == 0 { return .empty }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if isNumber{
            if self.characters.count == 4 {
                return .valid
            }else{ return .inValid }
        }else { return .notANumber }
    }
    
    var isValidZipCode : Status {
        if length < 0 { return .empty }
        if isEveryCharcterZero { return .allZeros }
        if isBlank { return .allSpaces }
        if !isNumber{ return .notANumber }
        return .valid
    }
    
    var isValidAmount :  Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if !isNumber{ return .notANumber }
        return .valid
    }
    
    var isValidDescription : Status {
        if length <= 0 { return .emptyPostDescription }
        if isBlank { return .emptyPostDescription }
        return .valid
    }
    
    var isValidPropertyInfo : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        if notOnlyString {return .hasSpecialCharacter}
        return .valid
    }
}



//VALIDATION OF PAYMENT
enum Fields :String
{
    case name = "([A-Z][a-z]*)([\\s\\\'-][A-Z][a-z]*)*"
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case cardNumber = "[0-9]"
    case cvv = "[0-9]{3}"
    
}
var count : Bool = false

public class FieldCheck
{
    static func validate(textValue:Fields, value : String) -> Bool
    {
        count = NSPredicate(format:"SELF MATCHES %@", textValue.rawValue).evaluate(with: value)
        return count
    }
}

