declare const REQUEST_TYPES: readonly ["payment", "staff_assistance", "extra_water", "extra_bowl", "extra_spoon"];
export declare class CreateStaffRequestDto {
    requestType: (typeof REQUEST_TYPES)[number];
    note?: string;
}
export declare class HandleStaffRequestDto {
    handledByUserId?: string;
}
export {};
