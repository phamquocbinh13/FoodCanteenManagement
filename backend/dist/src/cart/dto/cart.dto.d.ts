export declare class AddCartItemDto {
    menuItemId: string;
    quantity: number;
    selectionsJson?: Record<string, unknown>;
}
export declare class PatchCartItemDto {
    quantity?: number;
    delta?: number;
}
export declare class PutCartItemSelectionsDto {
    selectionsJson: Record<string, unknown>;
}
