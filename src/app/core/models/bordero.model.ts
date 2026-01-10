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
    total_cheques_value: string;
    cheques: ChequeOutput[];
}

export class BorderoPreview implements BorderoPreviewResponse {
    exchange_date: string;
    monthly_interest: string;
    total_cheques_value: string;
    cheques: ChequeOutput[];
    total_amount_to_receive: number;

    constructor(bordero: BorderoPreviewResponse) {
        this.exchange_date = bordero.exchange_date;
        this.monthly_interest = bordero.monthly_interest;
        this.total_cheques_value = bordero.total_cheques_value;
        this.cheques = bordero.cheques;
        this.total_amount_to_receive = (this.cheques || []).reduce((sum, cheque) => sum + (+cheque.amount_to_receive || 0), 0);
    }
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