
import Foundation

struct Room: Identifiable, Codable {

    var id: UUID
    var number: String
    var building: String
    var capacity: Int
    var status: String
    var issue: String

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case building
        case capacity
        case status
        case issue
    }

    init(
        id: UUID = UUID(),
        number: String,
        building: String,
        capacity: Int = 0,
        status: String = "Good",
        issue: String = ""
    ) {
        self.id = id
        self.number = number
        self.building = building
        self.capacity = capacity
        self.status = status
        self.issue = issue
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        id = try container.decode(UUID.self, forKey: .id)

        number = try container.decodeIfPresent(
            String.self,
            forKey: .number
        ) ?? ""

        building = try container.decodeIfPresent(
            String.self,
            forKey: .building
        ) ?? ""

        capacity = try container.decodeIfPresent(
            Int.self,
            forKey: .capacity
        ) ?? 0

        status = try container.decodeIfPresent(
            String.self,
            forKey: .status
        ) ?? "Good"

        issue = try container.decodeIfPresent(
            String.self,
            forKey: .issue
        ) ?? ""
    }
}
