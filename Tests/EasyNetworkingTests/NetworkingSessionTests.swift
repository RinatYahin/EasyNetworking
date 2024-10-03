import XCTest
@testable import EasyNetworking

final class NetworkingSessionTests: XCTestCase {
    
    var sut: NetworkSessionManager!
    var session: NetworkSessionMock!
    
    override func setUpWithError() throws {
        sut = NetworkSessionManager()
        session = NetworkSessionMock()
        sut.session = session
    }
    
    struct MockModel: Codable {
        let value: String
    }
    
    func mockData() -> Data? {
        return try? JSONEncoder().encode(MockModel(value: "string"))
    }
    
    func mockHTTPResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "url")!,
                               statusCode: 200,
                               httpVersion: nil,
                               headerFields: nil)!
    }
    
    func testSuccessLoadDataWithModel() {
        //arrange
        let request = MockNetworkRequest.getMethod(url: "url")
        session.data = mockData()
        session.response = mockHTTPResponse()
        
        let expectation = XCTestExpectation(description: "Called for data")
        
        //act
        sut.load(request: request) { (result: Result<MockModel>) in
            expectation.fulfill()
            //assert
            switch result {
            case .success(let returnedData):
                XCTAssertNotNil(returnedData)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

        }
        wait(for: [expectation], timeout: 5)
    }
}


class NetworkSessionMock: NetworkSession {
    
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?
    
    func get(request: URLRequest, completion: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        completion(data, response, error)
    }
    
}

enum MockNetworkRequest: NetworkRequest {
    case getMethod(url: String)
    
    var url: String {
        switch self {
        case .getMethod(let url):
            return url
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

