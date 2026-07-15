export declare class ConfirmBatchDto {
    actorType?: string;
    actorId?: string;
}
export declare class CreateBatchDto {
    batchNumber?: number;
    confirmedByActorType?: string;
    confirmedByActorId?: string;
}
export declare class CreateBatchItemDto {
    menuItemId: string;
    menuItemNameSnapshot: string;
    unitPriceMinor: number;
    currencyCode: string;
    quantity: number;
    lineTotalMinor: number;
    kitchenNotesRendered?: string;
}
export declare class BatchCustomizationDto {
    groupKey: string;
    groupNameSnapshot: string;
    optionKey?: string;
    optionNameSnapshot?: string;
    valueJson?: Record<string, unknown>;
    priceDeltaMinor?: number;
    currencyCode: string;
    kitchenLabelRendered: string;
}
export declare class BulkCustomizationsDto {
    customizations: BatchCustomizationDto[];
}
