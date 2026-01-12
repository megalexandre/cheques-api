export interface BorderoPreviewRequest {
    exchange_date: string;
    monthly_interest: number;
    cheques: ChequeInput[];
}

export interface ChequeInput {
    value: number;
    due_date: string;
    processing_days: number;
}

export interface BorderoPreviewResponse {
    exchange_date: string;
    monthly_interest: string;
    total_paid: string;
    total_value: string;
    cheques: ChequeOutput[];
}

export interface ChequeOutput {
    value: string;
    due_date: string;
    effective_due_date: string;
    processing_days: number;
    days_count: number;
    total_interest: string;
    paid_for_exchange: string;
    amount_to_receive: string;
}


 export const emptyCheque: ChequeInput = {
    value: 0,
    due_date: new Date().toISOString().split('T')[0],
    processing_days: 2
  };