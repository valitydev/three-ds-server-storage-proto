namespace java com.rbkmoney.damsel.threeds.server.storage
namespace erlang three_ds_server_storage

typedef string ThreeDsServerTransactionID
typedef string DirectoryServerProviderID
typedef string Timestamp
typedef string MessageVersion

exception ChallengeFlowTransactionInfoNotFound {}
exception DirectoryServerProviderIDNotFound {}

/** Карточный диапазон */
struct CardRange {
    1: required i64             range_start
    2: required i64             range_end
    3: required Action          action                      // emvco = optional
    4: required MessageVersion  acs_start
    5: required MessageVersion  acs_end
    6: required MessageVersion  ds_start                    // emvco = optional
    7: required MessageVersion  ds_end                      // emvco = optional
    8: optional string          acs_information_indicator   // emvco = optional
    9: optional string          three_ds_method_url         // emvco = optional
}

union Action {
    1: Add      add_card_range
    2: Delete   delete_card_range
    3: Modify   modify_card_range
}

struct Add {}
struct Delete {}
struct Modify {}

struct InitRBKMoneyPreparationFlowRequest {
    1: required DirectoryServerProviderID provider_id
    2: required MessageVersion            message_version
}

struct UpdateCardRangesRequest {
    1: required DirectoryServerProviderID   provider_id
    2: required MessageVersion              message_version
    3: required list<CardRange>             card_ranges
    4: required bool                        is_need_storage_clear
    5: optional string                      serial_number
}

union AccountNumberVersion {
    1: ThreeDsSecondVersion     three_ds_second_version
    2: UnsupportedVersion       unsupported_version
}

struct ThreeDsSecondVersion {
    1: required DirectoryServerProviderID   provider_id
    2: required MessageVersion              acs_start
    3: required MessageVersion              acs_end
    4: required MessageVersion              ds_start
    5: required MessageVersion              ds_end
    6: optional string                      three_ds_method_url
}

struct UnsupportedVersion {}

/** Вспомогательная информация по транзакции */
struct ChallengeFlowTransactionInfo {
    1: required ThreeDsServerTransactionID transaction_id
    2: required string                     device_channel
    3: required Timestamp                  decoupled_auth_max_time
    4: optional string                     acs_dec_con_ind
    5: required DirectoryServerProviderID  provider_id
    6: required MessageVersion             message_version
    7: required string                     acs_url
}

service PreparationFlowInitializer {

    /**
     * Требование к Storage инициировать обновление карточных диапазонов через 3DS Server
     */
    void InitRBKMoneyPreparationFlow(1: InitRBKMoneyPreparationFlowRequest request)

}

service CardRangesStorage {

    void updateCardRanges(1: UpdateCardRangesRequest request)

    bool IsStorageEmpty(1: DirectoryServerProviderID provider_id)

    bool IsValidCardRanges(1: DirectoryServerProviderID provider_id, 2: list<CardRange> card_ranges)

    DirectoryServerProviderID GetDirectoryServerProviderId(1: i64 account_number) throws (1: DirectoryServerProviderIDNotFound ex1)

    AccountNumberVersion GetAccountNumberVersion(1: i64 account_number)

}

service ChallengeFlowTransactionInfoStorage {

    /** Запрос на сохранение информации по транзакции */
    void SaveChallengeFlowTransactionInfo(1: ChallengeFlowTransactionInfo transaction_info)

    /** Запрос на получение информации по транзакции */
    ChallengeFlowTransactionInfo GetChallengeFlowTransactionInfo(1: ThreeDsServerTransactionID transaction_id) throws (1: ChallengeFlowTransactionInfoNotFound ex1)

}
