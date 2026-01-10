import { Component, OnInit } from '@angular/core';
import { BorderoService } from '../../core/services/bordero.service';
import { BorderoPreview, BorderoPreviewRequest, BorderoPreviewResponse, ChequeInput, emptyCheque } from '../../core/models/bordero.model';

@Component({
  selector: 'app-preview',
  templateUrl: './preview.component.html',
  styleUrls: ['./preview.component.scss'],
  standalone: false
})
export class PreviewComponent implements OnInit {

  request: BorderoPreviewRequest = {
    exchange_date: new Date().toISOString().split('T')[0],
    monthly_interest: 2.5,
    cheques: []
  };

  response: BorderoPreview | null = null;
  

  constructor(private borderoService: BorderoService) { }

  ngOnInit(): void {
    this.addCheque();
  }

  addCheque() {
    this.request.cheques.push({ ...emptyCheque });
  }

  removeCheque(index: number) {
    this.request.cheques.splice(index, 1);
  }

  calculate() {
    this.borderoService.calculatePreview(this.request).subscribe({
      next: (response) => {
        this.response = response;
      },
      error: (error) => {
        console.error('Error calculating preview', error);
      }
    });
  }
}
